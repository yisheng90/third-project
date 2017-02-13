class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)

    if @user.save!
      UserMailer.registration_confirmation(@user).deliver_later
      flash.now[:success] = 'Please check you mail box and confirm email'
      redirect_to login_path
    else
      flash.now[:error] = "Ooooppss, something went wrong!"
      render :new
    end
  end

  def update
    @user.update(user_params)

    if @user
      flash.now[:success] = 'Please check you mail box and confirm email'
      redirect_to user_path[id: @user.id]
    else
      flash.now[:error] = "Ooooppss, something went wrong!"
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :address, :profile_picture)
  end

end
