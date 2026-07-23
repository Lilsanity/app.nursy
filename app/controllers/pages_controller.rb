class PagesController < ApplicationController
  def home
    if params[:commune].present?
      @commune = Commune.find_by("name ILIKE ?", params[:commune])
      @nurses = @commune ? Nurse.joins(:commune).where(communes: { id: @commune.id }) : Nurse.none
    end
  end

  def my_space
    @user = current_user
    @appointments = @user.appointments.includes(:nurse, :availability).order(created_at: :desc)
  end

  def confirmation
    @appointment = Appointment.includes(:availability, nurse: :commune).find(params[:id])
  end
end
