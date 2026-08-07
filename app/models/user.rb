class User < ApplicationRecord
  has_one_attached :photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :appointments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  after_create :create_demo_appointment_with_claire

  private

  def create_demo_appointment_with_claire
    claire = Nurse.find_by(first_name: "Claire", last_name: "Fontaine")
    return unless claire

    availability = Availability.create!(
      nurse: claire,
      start_time: 2.days.ago.change(hour: 10),
      end_time:   2.days.ago.change(hour: 11),
      is_booked: true
    )

    Appointment.create!(
      nurse: claire,
      user: self,
      availability: availability,
      status: "Confirmé"
    )
  end
end
