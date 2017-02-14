class BookingsController < ApplicationController
  def create

    # FREELANCER ID
    @freelancer = Freelancer.find(params[:id])

    # ENQUIRY ID
    @enquiry = Enquiry.find(params[:id])

    enquiry.book! @freelancer, time_start: params[:start_time], time_end: params[:end_time]
  end
end
