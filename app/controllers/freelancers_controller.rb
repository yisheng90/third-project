class FreelancersController < ApplicationController
  include FreelancersHelper
  before_action :check_user
  before_action :is_freelancer?, except: [:index,:new, :create]

  def new
    if Freelancer.find_by(user_id: current_user[:id])
      redirect_to profile_index_path
    end
    puts current_user.name
    @freelancer = Freelancer.new
  end

  def index
    @freelancers = Freelancer.all
  end

  def show
    @freelancer = Freelancer.find_by(id: params[:id])
    @bookings = @freelancer.bookings

    # not clean could refactor into function ZL
    if @freelancer.ratings.average('professionalism').is_a? Numeric
      @compiled_rating = ( @freelancer.ratings.average('professionalism') +
                            @freelancer.ratings.average('value') +
                            @freelancer.ratings.average('cleanliness') ) / 3
    else
      @compiled_rating = nil
    end

    @enquiries = Enquiry.all.where(freelancer_id: params[:id]).where(status: 'open')
    @occurrences = @freelancer.schedule.occurrences_between(Date.today - 1.year,Date.today + 1.year)
    @sanitized_start_time = @freelancer.schedule.start_time.strftime("%I:%M%p")
    @sanitized_end_time = @freelancer.schedule.end_time.strftime("%I:%M%p")
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
    # HELPER FUNCTION -> DELETE PRE RECURRENCES
    delete_recurrence_rule(@freelancer)
    # SAVE AFTER REMOVE RULE
    @freelancer.save
    if @freelancer.update(freelancer_params)
      # HELPER FUNCTION -> UPDATE SCHEDULE COLUMN
      fl_schedule_column(@freelancer)
      # HELPER FUNCTION -> UPDATE CAPACITY COLUMN
      fl_capacity_column(@freelancer, params[:capacity])
      # SAVE AFTER UPDATE COLUMN
      @freelancer.save
      # HELPER FUNCTION -> UPDATE DAILY RECURRENCE
      if params[:days]
        recurrence_rule(@freelancer)
        # SAVE AFTER UPDATE COLUMN
        @freelancer.save
      end

      flash[:success] = 'updated profile!'
      redirect_to profile_path(@freelancer.user_id)
    else
      flash[:danger] = 'unable to update profile'
      redirect_to profile_path(@freelancer.user_id)
    end
  end

  def create
    @freelancer = Freelancer.new(freelancer_params)
    @freelancer.user_id = current_user[:id]
    # HELPER FUNCTION -> CREATE FREELANCER SCHEDULE COLUMN
    fl_schedule_column(@freelancer)
    # HELPER FUNCTION -> UPDATE CAPACITY COLUMN
    fl_capacity_column(@freelancer, params[:capacity])
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
        :description,
        :picture,
        :start_working_hours,
        :end_working_hours,
        :price_start,
        :price_end,
        :capacity,
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
end
