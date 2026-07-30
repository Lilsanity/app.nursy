class Review < ApplicationRecord
  belongs_to :user
  belongs_to :nurse
  belongs_to :appointment, optional: true

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :appointment_id, uniqueness: true, allow_nil: true
end
