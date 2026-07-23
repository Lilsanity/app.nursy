class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :nurse
  belongs_to :availability

  validates :availability_id, uniqueness: true

  def upcoming?
    availability.start_time > Time.current
  end

  def reschedulable_slots
    nurse.availabilities
         .where(is_booked: [false, nil])
         .or(Availability.where(id: availability_id))
         .where("start_time > ?", Time.current)
         .order(:start_time)
  end
end
