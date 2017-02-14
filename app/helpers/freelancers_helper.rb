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
    debugger
    @freelancer.save
  end

  def string_to_symbol_scrub(array)
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
    scrubbed_days = string_to_symbol_scrub(params[:days])

    # ADDING RECURRENCE TO ICE_CUBE SCHEDULING
    @freelancer.schedule.add_recurrence_rule IceCube::Rule.weekly.day(scrubbed_days)
    @freelancer.save
  end

  def integer_to_date(arr)
    res = []
    arr.each do | number |
      res << Date::DAYNAMES[number]
    end
    res
  end

  def delete_recurrence_rule(user_id)
    @freelancer = Freelancer.find_by_id(user_id)

    # FIRST RECURRENCE IN SCHEDULE VALIDATION
    freelancer_schedule_validation = @freelancer.schedule.rrules.shift

    # DELETE RECURRENCE IN ICE_CUBE SCHEDULE RULE
    @freelancer.schedule.remove_recurrence_rule(freelancer_schedule_validation)

    # SAVE AFTER DELETE
    @freelancer.save
  end
end
