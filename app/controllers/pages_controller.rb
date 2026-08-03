class PagesController < ApplicationController
  def home
    return unless params[:commune].present?

    @commune = Commune.find_by("name ILIKE ?", params[:commune])
    @nurses = @commune ? Nurse.joins(:commune).where(communes: { id: @commune.id }) : Nurse.none
  end

  def my_space
    @user = current_user
    all_appointments = @user.appointments.includes(:nurse, :availability, :review).order(created_at: :desc)
    @appointments = all_appointments.select(&:upcoming?)
    @reviewable_appointments = all_appointments.reject(&:upcoming?).select { |a| a.review.blank? }
    @calendar_month = params[:month].present? ? Date.parse(params[:month]) : Date.today.beginning_of_month
  end

  def update_photo
    current_user.photo.attach(params[:photo])
    redirect_to my_space_path
  end

  def confirmation
    @appointment = Appointment.includes(:availability, nurse: :commune).find(params[:id])
  end
end
