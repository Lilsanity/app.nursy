class NursesController < ApplicationController
  def index
    joined_commune = false

    if params[:commune].present?
      commune = Commune.find_by("name ILIKE ?", params[:commune])
      if commune
        @nurses = Nurse.joins(:commune).where(communes: { id: commune.id })
        @commune = commune
        joined_commune = true
      else
        @nurses = Nurse.none
        @not_found = true
      end
    else
      @nurses = Nurse.all
    end

    @nurses = @nurses.where("average_rating >= ?", params[:min_rating]) if params[:min_rating].present?

    if params[:specialty].present?
      @nurses = @nurses.joins(:specialties).where(specialties: { name: params[:specialty] }).distinct
    end

    if params[:availability].present?
      case params[:availability]
      when "today"
        @nurses = @nurses.joins(:availabilities)
                         .where(availabilities: { is_booked: false })
                         .where("availabilities.start_time BETWEEN ? AND ?", Time.current.beginning_of_day, 3.days.from_now.end_of_day)
                         .distinct
      when "week"
        @nurses = @nurses.joins(:availabilities)
                         .where(availabilities: { is_booked: false })
                         .where("availabilities.start_time BETWEEN ? AND ?", Time.current.beginning_of_day, 7.days.from_now.end_of_day)
                         .distinct
      end
    end

    if params[:distance].present?
      ref_lat = @commune&.latitude || 48.8566
      ref_lng = @commune&.longitude || 2.3522
      max_km = params[:distance].to_f

      @nurses = @nurses.joins(:commune) unless joined_commune
      @nurses = @nurses.where(
        "(6371 * acos(LEAST(1, GREATEST(-1, cos(radians(?)) * cos(radians(communes.latitude)) * cos(radians(communes.longitude) - radians(?)) + sin(radians(?)) * sin(radians(communes.latitude)))))) <= ?",
        ref_lat, ref_lng, ref_lat, max_km
      )
    end

    case params[:sort]
    when "rating"
      @nurses = @nurses.order(average_rating: :desc)
    when "distance"
      ref_lat = @commune&.latitude || 48.8566
      ref_lng = @commune&.longitude || 2.3522
      @nurses = @nurses.joins(:commune) unless joined_commune || params[:distance].present?
      @nurses = @nurses.select(
        "nurses.*, (6371 * acos(LEAST(1, GREATEST(-1, cos(radians(#{ref_lat})) * cos(radians(communes.latitude)) * cos(radians(communes.longitude) - radians(#{ref_lng})) + sin(radians(#{ref_lat})) * sin(radians(communes.latitude)))))) AS distance_km"
      ).order("distance_km ASC")
    end
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
