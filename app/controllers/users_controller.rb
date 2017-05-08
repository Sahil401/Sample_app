class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index,:edit,:update,:destroy,:following,:followers]
  before_action :correct_user, only: [:edit,:update] 
  before_action :admin_user, only: :destroy

  def create
  	@user=User.find_by(email: params[:user][:email].downcase)
  	if @user && @user.authenticate(params[:user][:password])
      sign_in @user
      flash[:sucess] = "Welcome to the Sample App!"
  		redirect_to root_url
  	else
      @user = User.create(user_params)
      if @user.save
        sign_in @user
        flash[:sucess] = "Welcome to the Sample App!"
        redirect_to root_url
      else
        render 'new'
  	 end
    end
  end

  def count(date)
    where("date(followers) = ?", date).count
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def index
    @users= User.paginate(page: params[:page])
  end

  def new
  	@user=User.new
  end

  def show
  @user = User.find(params[:id])
  @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
    if params[:change_password] == "true"
      @pass = true
    else
      @pass = false
    end
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:email]
      if @user.update_attributes(params.require(:user).permit(:name,:email))
        flash[:sucess]="Sucessfully updated the information"
        redirect_to @user
      else
        render 'edit'
      end
    else
      if @user.update_attributes(params.require(:user).permit(:password,:password_confirmation)) 
        flash[:sucess]="Sucessfully updated the information"
        redirect_to @user
      else
        render 'edit'
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

  def user_params
  	params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end

  def correct_user
    @user=User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end 

  def admin_user
      redirect_to(root_url) unless current_user.admin?
  end

end
