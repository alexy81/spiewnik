class UsersController < ApplicationController
  layout "users"
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Logowanie poprawne"
      Mailer.nowy_uzytkownik(@user).deliver
      redirect_to '/'
    else
      render 'new'
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
