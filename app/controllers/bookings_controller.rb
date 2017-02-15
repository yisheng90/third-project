class BookingsController < ApplicationController
  before_action :check_user
  before_action :is_freelancer?

  def create
    # FREELANCER ID
    @freelancer = Freelancer.find(params[:id])
    # ENQUIRY ID
    @enquiry = Enquiry.find(params[:id])
    if enquiry.book! @freelancer, time_start: params[:start_time], time_end: params[:end_time]
      flash[:success] = 'Booking created!'
      redirect_to bookings_index_path
    else
      flash[:danger] = 'Please login in to use the service!'
      redirect_to bookings_index_path
    end
  end

  def index
    @bookings_fl = current_freelancer.bookings
    @bookings_user = Enquiry.find_by(user_id: current_user.id).bookings
  end

  private

  def is_freelancer?
    if !current_freelancer
      flash[:danger] = 'Unauthorized user!!'
      redirect_to profile_index_path
    end
  end

  def check_user
    if !current_user
      flash[:danger] = 'Please login in to use the service!'
      redirect_to login_path
    end
  end
end
