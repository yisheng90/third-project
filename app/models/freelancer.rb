class Freelancer < ApplicationRecord
  belongs_to :user

  # ASSOCIATIONS (ANDREW)
  has_many :enquires, dependent: :destroy
  has_many :bookings, dependent: :destroy
  # BOOKABLE GEM (ANDREW)
  acts_as_bookable time_type: :range, bookable_across_occurrences: true

  validates :user_id,

  uniqueness: true

end
