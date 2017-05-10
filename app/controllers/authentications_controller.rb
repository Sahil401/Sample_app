class AuthenticationsController < ApplicationController
  def index
    @authentications = authentications.all
  end

  def create  
    omniauth = request.env["omniauth.auth"]
    @var = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if @var
      flash[:notice] = "Signed in successfully."
      sign_in User.find_by(email: omniauth['info']['email'])
      redirect_to root_url
    elsif current_user
    current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
    flash[:notice] = "Authentication successful."
    redirect_to authentications_url
    else
      user = User.new
      user.is_twitter = true
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in user
        redirect_to root_url
      else
        check = User.find_by(email: omniauth['info']['email'])
        if check
          sign_in check
          redirect_to root_url
        end
      end
    end
  end
  def destroy
    
  end
end
