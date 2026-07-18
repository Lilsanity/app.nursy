class NursesController < ApplicationController
  def index # rubocop:disable Metrics/MethodLength
    if params[:commune].present?
      commune = Commune.find_by("name ILIKE ?", params[:commune])
      if commune
        @nurses = Nurse.search("*",
                               where: {
                                 location: { near: { lat: commune.latitude, lon: commune.longitude }, within: "30km" }
                               })
        @commune = commune
      else
        @nurses = Nurse.none
        @not_found = true
      end
    else
      @nurses = Nurse.all
    end
  end

  def show
    @nurse = Nurse.find(params[:id])
  end
end
