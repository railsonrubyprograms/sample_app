class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      # Create an error message
      flash.now[:danger] = 'Email and password did not match'
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end
end