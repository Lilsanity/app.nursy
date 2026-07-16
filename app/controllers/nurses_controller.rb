class NursesController < ApplicationController
  def index
    @nurses = Nurse.all
  end

  def show
    @nurse = Nurse.find(params[:id])
  end
end
