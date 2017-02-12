class PasswordResetController < ApplicationController
  # def show
  #   @user = User.find_by_reset_token(params[:id])
  #
  #   if @user
  #     @user.email_activate
  #     flash[:success] = "Welcome to the Sample App! Your email has been confirmed. \n Please sign in to continue."
  #     redirect_to login_url
  #   else
  #     flash[:error] = "Sorry. User does not exist"
  #     redirect_to root_url
  #   end
  # end

  def new
  end

  def create
    @user = User.find_by_email(password_reset_params[:email])

    if @user
      @user.set_reset_token
      UserMailer.password_reset(@user).deliver_later
      flash.now[:success] = 'Please check you mail box'
      redirect_to login_path
    else
      flash.now[:danger] = 'Please enter a valid email'
      render :new
    end
  end

  def edit
    @user = User.find_by_reset_token(params[:id])

    if !@user
      flash.now[:danger] = 'Ooooppss. Something went wrong.'
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by_reset_token!(params[:id])

    @user.password = user_params[:password]
    if @user.save!
      @user.confirm_password_reset
      flash.now[:success] = 'Password reseted'
      redirect_to login_path
    else
      flash.now[:danger] = 'Error'
      render :new
    end
  end

  private

  def password_reset_params
    params.require(:password_reset).permit(:email)
  end

  def user_params
    params.require(:user).permit(:password)
  end

end
