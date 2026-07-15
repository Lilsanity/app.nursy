class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :nurse
  belongs_to :availability
end
