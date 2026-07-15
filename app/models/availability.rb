class Availability < ApplicationRecord
  belongs_to :nurse
  has_one :appointment, dependent: :destroy
end
