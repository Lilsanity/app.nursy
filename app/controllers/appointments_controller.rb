class AppointmentsController < ApplicationController
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user

    if book_appointment
      redirect_to confirmation_path(@appointment)
    else
      redirect_to nurse_path(appointment_params[:nurse_id]), alert: @appointment.errors.full_messages.to_sentence
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  private

  def book_appointment
    ActiveRecord::Base.transaction do
      availability = @appointment.availability&.lock!
      if availability.nil? || availability.is_booked
        @appointment.errors.add(:availability_id, "n'est plus disponible")
        raise ActiveRecord::Rollback
      end

      @appointment.save && availability.update!(is_booked: true)
    end
  end

  def appointment_params
    params.require(:appointment).permit(:nurse_id, :availability_id)
  end
end
