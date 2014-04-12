class SessionsController < ApplicationController
  layout "users"
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to '/'
    else
      flash.now[:error] = 'Nieprawidłowy email lub hasło'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to '/'
  end
  
end
