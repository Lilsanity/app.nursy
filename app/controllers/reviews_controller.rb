class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    appointment = current_user.appointments.find(review_params[:appointment_id])
    return reject_review unless reviewable?(appointment)

    review = Review.new(review_params.merge(nurse_id: appointment.nurse_id, user_id: current_user.id))

    if review.save
      redirect_to my_space_path, notice: "Merci pour votre avis !"
    else
      redirect_to my_space_path, alert: review.errors.full_messages.to_sentence
    end
  end

  private

  def reviewable?(appointment)
    !appointment.upcoming? && appointment.review.blank?
  end

  def reject_review
    redirect_to my_space_path, alert: "Impossible de laisser un avis pour ce rendez-vous."
  end

  def review_params
    params.require(:review).permit(:appointment_id, :rating, :comment)
  end
end
