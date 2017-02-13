class Freelancer < ApplicationRecord
  belongs_to :user
  has_many :enquires, dependent: :destroy
  has_many :bookings, dependent: :destroy
end
