class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit,:update]
  before_action :correct_user, only: [:edit,:update] 
  before_action :admin_user, only: :destroy

  def create
  	user=User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      sign_in user
      flash[:sucess] = "Welcome to the Sample App!"
  		redirect_back_or user
  	else
      flash[:error] = "Invalid email/password combination"
  		render 'new'
  	end
  end

  def index
    @users= User.paginate(page: params[:page])
  end

  def new
  	@user=User.new
  end

  def show
  @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:sucess]="Sucessfully updated the information"
      redirect_to @user
    else
      render 'edit'
  end
  end

  def destroy
    byebug
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

  def user_params
  	params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path ,notice: "Please Sign in."
  end
  end 

  def correct_user
    @user=User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end 

  def admin_user
      redirect_to(root_url) unless current_user.admin?
  end

end
