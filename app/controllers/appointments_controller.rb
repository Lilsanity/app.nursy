class AppointmentsController < ApplicationController
  def new
    @nurse = Nurse.find(params[:nurse_id])
    @appointment = Appointment.new
    @availabilities = @nurse.availabilities.where(is_booked: [false, nil]).where('start_time > ?', Time.current).order(start_time: :asc)
  end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user
    if @appointment.save
      redirect_to confirmation_path(@appointment)
    else
      @nurse = @appointment.nurse
      @availabilities = @nurse.availabilities.where(is_booked: [false, nil]).where('start_time > ?', Time.current).order(start_time: :asc)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  private

  def appointment_params
    params.require(:appointment).permit(:nurse_id, :availability_id, :care_type, :address)
  end
end
