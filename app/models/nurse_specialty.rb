class NurseSpecialty < ApplicationRecord
  belongs_to :nurse
  belongs_to :specialty
end
