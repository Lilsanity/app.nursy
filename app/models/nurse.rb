class Nurse < ApplicationRecord
  MALE_FIRST_NAMES = %w[
    Antoine Julien Marc Hugo Thomas Lucas Jean Pierre Paul
    Nicolas David Mathieu Romain Baptiste Kevin Alexandre
  ].freeze

  has_one_attached :photo

  belongs_to :commune
  has_many :nurse_specialties, dependent: :destroy
  has_many :specialties, through: :nurse_specialties
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  def female?
    !MALE_FIRST_NAMES.include?(first_name)
  end
end
