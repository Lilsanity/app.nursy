class NursesController < ApplicationController
  def index
    if params[:commune].present?
      commune = Commune.find_by("name ILIKE ?", params[:commune])
      if commune
        @nurses = Nurse.joins(:commune).where(communes: { id: commune.id })
        @commune = commune
      else
        @nurses = Nurse.none
        @not_found = true
      end
    else
      @nurses = Nurse.all
    end

    @nurses = @nurses.where("average_rating >= ?", params[:min_rating]) if params[:min_rating].present?
    return unless params[:specialty].present?

    @nurses = @nurses.joins(:specialties).where(specialties: { name: params[:specialty] }).distinct
  end

  def show
    @nurse = Nurse.includes(:commune, :specialties).find(params[:id])
    @availabilities = @nurse.availabilities
                            .where(is_booked: false)
                            .where('start_time >= ?', Time.current)
                            .order(:start_time)
                            .limit(6)
    @reviews = @nurse.reviews.includes(:user).order(created_at: :desc)
  end
end
