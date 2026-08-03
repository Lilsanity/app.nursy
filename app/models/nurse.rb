class Nurse < ApplicationRecord
  MALE_FIRST_NAMES = %w[
    Antoine Julien Marc Hugo Thomas Lucas Jean Pierre Paul
    Nicolas David Mathieu Romain Baptiste Kevin Alexandre
  ].freeze

  SPECIALTY_COLORS = {
    "Pansements complexes" => "teal",
    "Vaccination" => "blue",
    "Soins Palliatifs" => "pink",
    "Pédiatrie" => "purple",
    "Gériatrie" => "orange",
    "Injections" => "indigo",
    "Perfusions" => "cyan",
    "Suivi diabétique" => "amber",
    "Soins post-op." => "green",
    "Personnes âgées" => "red"
  }.freeze
  DEFAULT_SPECIALTY_COLOR = "teal"

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

  def card_color
    first_specialty = nurse_specialties.order(:id).first&.specialty
    specialty_color(first_specialty&.name)
  end

  def specialty_color(specialty_name)
    SPECIALTY_COLORS[specialty_name] || DEFAULT_SPECIALTY_COLOR
  end
end
