class FreelancersController < ApplicationController
  before_action :check_user, except: [:index]
  before_action :is_freelancer?, except: [:index,:new, :create]
  def new
    if Freelancer.find_by(user_id: current_user[:id])
      redirect_to profile_index_path
    end
    puts current_user.name
    @freelancer = Freelancer.new
  end

  def index
    # @listings = Listings.all
    @freelancer = Freelancer.all
  end

  def show
    @freelancer = Freelancer.find_by(id: params[:id])
  end

  def edit
    @freelancer = Freelancer.find_by(id: params[:id])
  end

  def update
    @freelancer = Freelancer.find_by(id: params[:id])
    if @freelancer.update(freelancer_params)
      debugger
      redirect_to profile_path(@freelancer.user_id)
    end
  end

  def create
    @freelancer = Freelancer.new(freelancer_params)
    @freelancer.user_id = current_user[:id]
    if @freelancer.save
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
        :price_end)
    end
    def check_user
      if !current_user
        redirect_to login_path
      end
    end
    def is_freelancer?
      if !Freelancer.find_by(id: params[:id])
        redirect_to profile_index_path
      end
    end
end
