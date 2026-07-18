class Nurse < ApplicationRecord
  belongs_to :commune
  has_many :nurse_specialties, dependent: :destroy
  has_many :specialties, through: :nurse_specialties
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  searchkick locations: [:location]

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      location: { lat: commune.latitude, lon: commune.longitude }
    }
  end
end
