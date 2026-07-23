class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :nurse
  belongs_to :availability

  validates :availability_id, uniqueness: true
end
