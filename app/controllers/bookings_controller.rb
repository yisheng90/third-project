class BookingsController < ApplicationController
  def index
    @freelancer = Freelancer.find_by_id(current_user.id)
    debugger
    @bookings = @freelancer.schedule.first(3)
  end

  def show
  end

  def new
    @freelancer = Freelancer.find_by_id(params[:id])
    @booking = Enquiry.find_by(user_id: user.id).book! @freelancer, time_start: bookings_params[:start_time], time_end: bookings_params[:end_time]
  end

  def edit
  end

  def update
    @freelancer = Freelancer.find_by_id(params[:id])
    @bookings = @freelancer.bookings
  end

  def destroy
    @freelaner = Freelancer.find_by_id(params[:id])
  end
end
