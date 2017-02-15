class Freelancer < ApplicationRecord
  # ASSOCIATIONS (ANDREW)
  belongs_to :user
  has_many :enquires, dependent: :destroy
  has_many :bookings, dependent: :destroy

  # BOOKABLE GEM (ANDREW)
  acts_as_bookable time_type: :range, bookable_across_occurrences: true, capacity_type: :open

  validates :user_id, uniqueness: true

  after_validation :convert_to_utc, :if => :working_hours_set

  def convert_to_utc
    @freelancer = Freelancer.find_by_id(id)
    @freelancer.start_working_hours = @freelancer.start_working_hours.to_time.utc
    @freelancer.end_working_hours = @freelancer.end_working_hours.to_time.utc
  end

  private

  def working_hours_set
    @freelancer = Freelancer.find_by_id(id)
    if @freelancer
      if @freelancer.start_working_hours && @freelancer.end_working_hours
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
