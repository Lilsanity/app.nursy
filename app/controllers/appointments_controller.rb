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

  def update
    @appointment = current_user.appointments.find(params[:id])

    if @appointment.upcoming?
      if reschedule_appointment(update_params[:availability_id])
        redirect_to my_space_path, notice: "Rendez-vous modifié."
      else
        redirect_to my_space_path, alert: @appointment.errors.full_messages.to_sentence
      end
    else
      redirect_to my_space_path, alert: "Ce rendez-vous est déjà passé."
    end
  end

  def destroy
    @appointment = current_user.appointments.find(params[:id])

    if @appointment.upcoming?
      cancel_appointment
      redirect_to my_space_path, notice: "Rendez-vous annulé."
    else
      redirect_to my_space_path, alert: "Ce rendez-vous est déjà passé."
    end
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

  def reschedule_appointment(new_availability_id)
    ActiveRecord::Base.transaction do
      old_availability = @appointment.availability&.lock!
      new_availability = Availability.lock.find_by(id: new_availability_id)

      next true if new_availability&.id == old_availability&.id

      raise ActiveRecord::Rollback unless slot_still_free?(new_availability)
      raise ActiveRecord::Rollback unless @appointment.update(availability_id: new_availability.id)

      old_availability&.update!(is_booked: false)
      new_availability.update!(is_booked: true)
      true
    end
  end

  def slot_still_free?(new_availability)
    return true if new_availability && !new_availability.is_booked

    @appointment.errors.add(:availability_id, "n'est plus disponible")
    false
  end

  def cancel_appointment
    ActiveRecord::Base.transaction do
      availability = @appointment.availability&.lock!
      @appointment.destroy!
      availability&.update!(is_booked: false)
    end
  end

  def appointment_params
    params.require(:appointment).permit(:nurse_id, :availability_id)
  end

  def update_params
    params.require(:appointment).permit(:availability_id)
  end
end
