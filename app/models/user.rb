class User < ApplicationRecord
  has_one_attached :photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :appointments, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
