class FreelancersController < ApplicationController
  include FreelancersHelper

  before_action :check_user, except: [:index, :show]
  before_action :is_freelancer?, except: [:index,:new, :create]


  def new
    if Freelancer.find_by(user_id: current_user[:id])
      redirect_to profile_index_path
    end
    puts current_user.name
    @freelancer = Freelancer.new
  end

  def index
    @freelancers = Freelancer.search(params[:search])
  end

  def show
    @freelancer = Freelancer.find_by(id: params[:id])
    @bookings = @freelancer.bookings
    @dummy_data = 'Hello'
    @enquiry = Enquiry.new
    # not clean could refactor into function ZL
    if @freelancer.ratings.average('professionalism').is_a? Numeric
      @compiled_rating = ( @freelancer.ratings.average('professionalism') +
                            @freelancer.ratings.average('value') +
                            @freelancer.ratings.average('cleanliness') ) / 3
    else
      @compiled_rating = nil
    end

    @enquiries = Enquiry.all.where(freelancer_id: params[:id]).where(status: 'open')

    #pass in data as a hash
    @sanitized_start_time = @freelancer.schedule.start_time.strftime("%I:%M%p")
    @sanitized_end_time = @freelancer.schedule.end_time.strftime("%I:%M%p")
    # @freelancer.bookings.each do |freelancer_booking|
      #### YOU STOPPED HERE ZL
    # @freelancer_bookings_start = @freelancer.bookings[0].time_start
    # @freelancer_bookings_end = @freelancer.bookings[0].time_end
    @occurrences = {
      dates: @freelancer.schedule.occurrences_between(Date.today - 1.year,Date.today + 1.year),
      test: @dummy_data,
      start_time: @sanitized_start_time,
      end_time: @sanitized_end_time,
      start_booked_times: @freelancer_bookings_start,
      end_booked_times: @freelancer_bookings_end
    }
  end

  def edit
    @freelancer = Freelancer.find_by(id: params[:id])
    # IF RECCURENCE RULE NOT 0
    if @freelancer.schedule.rrules.length != 0
      @freelancer_days = integer_to_date(@freelancer.schedule.to_hash[:rrules][0][:validations][:day])
    else
      # SET FREELANCER_DAYS TO MONDAY IF NO RECCURENCE SET
      @freelancer_days = integer_to_date([1])
    end
  end

  #CAPACITY IS THROWING AN ERROR for now
  def update
    @freelancer = Freelancer.find_by(id: params[:id])
      upload_picture
    @address = @freelancer.address
    if @address.blank?
      @freelancer.latitude = 0
      @freelancer.longitude = 0
    else
      response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{@address}&key=AIzaSyBCTtS1KnxXuh22lty2vDgBn54QlfhiVKM", verify: false)
      parsed_json = JSON.parse(response.body)
      puts "response is #{parsed_json}"
      @freelancer.latitude= parsed_json["results"][0]['geometry']['location']['lat']
      @freelancer.longitude= parsed_json["results"][0]['geometry']['location']['lng']
    end
    # HELPER FUNCTION -> DELETE PRE RECURRENCES
    delete_recurrence_rule(@freelancer)
    # SAVE AFTER REMOVE RULE

    @freelancer.save
    if @freelancer.update(freelancer_params)
      # HELPER FUNCTION -> UPDATE SCHEDULE COLUMN
      fl_schedule_column(@freelancer)
      # SAVE AFTER UPDATE COLUMN
      @freelancer.save
      # HELPER FUNCTION -> UPDATE DAILY RECURRENCE
      if params[:days]
        recurrence_rule(@freelancer)
        # SAVE AFTER UPDATE COLUMN
        @freelancer.save
      end

      flash[:success] = 'updated profile!'
      redirect_to profile_path(@freelancer.id)
    else
      flash[:danger] = 'unable to update profile'
      render :edit
    end
  end

  def create
    @freelancer = Freelancer.new(freelancer_params)
    @freelancer.user_id = current_user[:id]
    @address = @freelancer.address
    response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{@address}&key=AIzaSyBCTtS1KnxXuh22lty2vDgBn54QlfhiVKM", verify: false)
    parsed_json = JSON.parse(response.body)
    puts "response is #{parsed_json}"
    @freelancer.latitude= parsed_json["results"][0]['geometry']['location']['lat']
    @freelancer.longitude= parsed_json["results"][0]['geometry']['location']['lng']
    # HELPER FUNCTION -> CREATE FREELANCER SCHEDULE COLUMN
    fl_schedule_column(@freelancer)
    # HELPER FUNCTION -> UPDATE DAILY RECURRENCE
    if params[:days]
      recurrence_rule(@freelancer)
    end

    if @freelancer.save!
      flash[:success] = 'created a profile!'
      redirect_to profile_path(@freelancer.user_id)
    else
      flash[:danger] = 'something went wrong'
      render 'new'
    end
  end

  private
    def freelancer_params
      params.require(:freelancer).permit(
        :profession,
        :address,
        :latitude,
        :longitude,
        :experience,
        :description,
        :picture,
        :start_working_hours,
        :end_working_hours,
        :price_start,
        :price_end,
        :days)
    end

    def check_user
      if !current_user
        flash[:danger] = 'Please login in to use the service!'
        redirect_to login_path
      end
    end

    def is_freelancer?
      if !Freelancer.find_by(id: params[:id])
        redirect_to profile_index_path
      end
    end


  def upload_picture
   if params[:freelancer][:picture] != nil
     if @freelancer.valid?
       uploaded_file = params[:freelancer][:picture].path
       puts "PATH #{uploaded_file}"
       cloudnary_file = Cloudinary::Uploader.upload(uploaded_file)
       @freelancer.picture = cloudnary_file['public_id']
     end
     params[:freelancer].delete :picture
   end
  end
end
