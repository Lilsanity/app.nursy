class Specialty < ApplicationRecord
  has_many :nurse_specialties, dependent: :destroy
  has_many :nurses, through: :nurse_specialties
end
