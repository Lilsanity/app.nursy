class PagesController < ApplicationController
  def home
    if params[:commune].present?
      @nurses = Nurse.search_by_location(params[:commune])
      #set up elasticsearch à faire sur une autre branche
    end
  end
end
