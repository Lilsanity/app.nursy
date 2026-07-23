class Nurse < ApplicationRecord
  belongs_to :commune
  has_many :nurse_specialties, dependent: :destroy
  has_many :specialties, through: :nurse_specialties
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
