class Freelancer < ApplicationRecord
  belongs_to :user

  # ASSOCIATIONS (ANDREW)
  has_many :enquires, dependent: :destroy
  has_many :bookings, dependent: :destroy

  # BOOKABLE GEM (ANDREW)
  acts_as_bookable time_type: :range

  # VALIDATION (ZL)
  validates :id,
  uniqueness: true

end
