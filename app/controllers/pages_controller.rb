class PagesController < ApplicationController
  def home
    if params[:commune].present?
      commune = Commune.find_by("name ILIKE ?", params[:commune])
      @commune = commune
      @nurses = if commune
        Nurse.search("*",
          where: { location: { near: { lat: commune.latitude, lon: commune.longitude }, within: "30km" } }
        )
      else
        Nurse.none
      end
    end
  end
end
