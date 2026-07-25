class PagesController < ApplicationController
  def home
    return unless params[:commune].present?

    @commune = Commune.find_by("name ILIKE ?", params[:commune])
    @nurses = @commune ? Nurse.joins(:commune).where(communes: { id: @commune.id }) : Nurse.none
  end

  def my_space
    @user = current_user
    @appointments = @user.appointments.includes(:nurse, :availability).order(created_at: :desc)
  end

  def update_photo
    current_user.photo.attach(params[:photo])
    redirect_to my_space_path
  end

  def confirmation
    @appointment = Appointment.includes(:availability, nurse: :commune).find(params[:id])
  end
end
