class UsersController < ApplicationController
  def create
  	@user=User.new(user_params)
  	if @user.save
      flash[:sucess] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
      flash[:error] = "Sorry something Wrong"
  		render 'new'
  	end
  end
  def new
  	@user=User.new
  end

  def show
  @user = User.find(params[:id])
  end
  private

  def user_params
  	params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
end
