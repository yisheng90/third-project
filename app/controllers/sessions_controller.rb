class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(user_params)
    if user
      if user.email_confirmed == 1
        session[:user_id] = user.id
        cookies.signed[:user_id] = user.id
        flash.now[:success] = "Wlecome #{user.name}. You have logged in."
        redirect_to root_path
      else
        flash.now[:danger] = 'Please activate your account by following the
        instructions in the account confirmation email you received to proceed'
        render 'new'
      end
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
       render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.signed[:user_id] = nil
    flash[:success] = "You have logged out."
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end


end
