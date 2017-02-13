class FreelancersController < ApplicationController
  def new
    @freelancer = Freelancer.new
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
      redirect_to @freelancer
    end
  end

  def create
    @freelancer = Freelancer.new(freelancer_params)
    if @freelancer.save
      flash[:success] = 'created a profile!'
      redirect_to @freelancer
    else
      flash[:danger] = 'something went wrong'
      render 'new'
    end
  end

  private def freelancer_params
    params.require(:freelancer).permit(
      :profession,
      :description,
      :picture,
      :start_working_hours,
      :end_working_hours,
      :price_start,
      :price_end)
  end
end
