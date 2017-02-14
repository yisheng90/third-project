class Freelancer < ApplicationRecord
  # ASSOCIATIONS (ANDREW)
  belongs_to :user
  has_many :enquires, dependent: :destroy
  has_many :bookings, dependent: :destroy

  attr_accessor :user
  # BOOKABLE GEM (ANDREW)
  acts_as_bookable time_type: :range, bookable_across_occurrences: true

  validates :user_id, uniqueness: true

  # UPDATE SCHEDULE COLUMN IF WORKING HOURS CHANGE
  before_update :update_fl_schedule_column, :if => "start_working_hours_changed? && end_working_hours_change?"

  def local_time_scrub(datetime)
    datetime.in_time_zone("Singapore").to_time
  end

  def print_working_hours(start_t, end_t)
    puts start_t
    puts end_t
  end

  def update_fl_schedule_column
    if current_user
      # FIND FREELANCER
      @freelancer = Freelancer.find_by_id(current_user.id)

      # FIND START AND END WORKING HOURS
      @fl_start_time = local_time_scrub(@freelancer.start_working_hours)
      @fl_end_time = local_time_scrub(@freelancer.end_working_hours)

      # PRINT BOTH START AND END
      print_working_hours(@fl_start_time, @fl_end_time)

      # SET DURATION OF WORKING HOURS
      @duration = (((@fl_start_time - @fl_end_time) / 1.hour).round).abs
      puts @duration

      # SET FREELANCER SCHEDULE
      @freelancer.schedule = IceCube::Schedule.new(@fl_start_time, duration: @duration.hours)
      @freelancer.save
    end
  end

  def check_id
    "freelancer_id:#{id}, user_id: #{user_id}"
  end
end
