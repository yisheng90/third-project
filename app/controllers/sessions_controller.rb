class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(user_params)
    if user
      if user.email_confirmed == 1
        session[:user_id] = user.id
        flash[:success] = "Welcome #{user.name}. You have logged in."
        unless !!Freelancer.find_by(user_id: current_user[:id])
          redirect_to profile_index_path
        else
          @freelancer = Freelancer.find_by(user_id: current_user[:id])
          redirect_to profile_path(@freelancer)
        end
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
    flash[:success] = "You have logged out."
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end


end
