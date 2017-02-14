class Freelancer < ApplicationRecord
  # ASSOCIATIONS (ANDREW)
  belongs_to :user
  has_many :enquires, dependent: :destroy
  has_many :bookings, dependent: :destroy

  # BOOKABLE GEM (ANDREW)
  acts_as_bookable time_type: :range, bookable_across_occurrences: true

  validates :user_id, uniqueness: true

  after_validation :convert_to_utc

  def convert_to_utc
    @freelancer = Freelancer.find_by_id(id)
    @freelancer.start_working_hours = @freelancer.start_working_hours.to_time.utc
    @freelancer.end_working_hours = @freelancer.end_working_hours.to_time.utc
  end

end
