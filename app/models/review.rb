class Review < ApplicationRecord
  belongs_to :user
  belongs_to :nurse
  belongs_to :appointment
end
