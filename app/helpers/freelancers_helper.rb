module FreelancersHelper
  def local_time_scrub(datetime)
    datetime.in_time_zone("Singapore").to_time
  end

  def print_working_hours(start_t, end_t)
    puts start_t
    puts end_t
  end

  def update_fl_schedule_column(user_id)
    # FIND FREELANCER
    @freelancer = Freelancer.find_by_id(user_id)

    # FIND START AND END WORKING HOURS
    @fl_start_time = @freelancer.start_working_hours.to_time
    @fl_end_time = @freelancer.end_working_hours.to_time

    # PRINT BOTH START AND END
    print_working_hours(@fl_start_time, @fl_end_time)

    # SET DURATION OF WORKING HOURS
    @duration = (((@fl_start_time - @fl_end_time) / 1.hour).round).abs
    puts @duration

    # SET FREELANCER SCHEDULE
    @freelancer.schedule = IceCube::Schedule.new(@fl_start_time, duration: @duration.hours)
    @freelancer.save
  end

  def string_to_symbol_scrub(array)
    debugger
    day_arr = []
    array.each do | day |
      day = day.downcase.to_sym
      day_arr << day
    end
    day_arr
  end

  def update_recurrence_rule(user_id)
    @freelancer = Freelancer.find_by_id(user_id)
    # SCRUB STRING TO SYMBOLS
    srubbed_days = string_to_symbol_scrub(params[:days])

    @freelancer.schedule.add_reccurrence_rule IceCube::Rule.weekly.day(scrubbed_days)
    @freelancer.save
  end
end
