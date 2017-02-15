class BookingsController < ApplicationController
  before_action :check_user
  before_action :is_freelancer?

  def create
    # ENQUIRY SEARCH
    debugger
    @enquiry = Enquiry.find(params[:enquiry][:id])
    # FREELANCER SEARCH BY ENQUIRY freelancer_id
    @freelancer = Freelancer.find(@enquiry.freelancer_id)
    # SCRUB PARAMS STRING TO TIME
    start_date = params[:enquiry][:start_date].to_time
    end_date = params[:enquiry][:end_date].to_time
    # BOOK FREELANCER
    if @enquiry.book! @freelancer, time_start: start_date, time_end: end_date
      flash[:success] = 'User booked!'
      redirect_to edit_enquiry_path(@enquiry)
    else
      flash[:danger] = 'Error in booking..'
      redirect_to edit_enquiry_path(@enquiry)
    end
  end

  def index
    @bookings_fl = current_freelancer.bookings
    @bookings_user = Enquiry.find_by(user_id: current_user.id).bookings
  end

  private

  def booking_params
    params.require(@enquiry).permit(
      :description,
      :start_date,
      :end_date,
      :price,
      :id)
  end

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
