class SessionsController < ApplicationController

def new
	redirect_to user_path(current_user) if current_user.present?
end

def destroy
	sign_out
	redirect_to root_url
end

def create
	user=User.find_by(email: params[:session][:email])
	if user
		if user.authenticate(params[:session][:password])
			sign_in user
			redirect_to root_url
		else
			flash[:error]="Wrong password/email combination"
			redirect_to signin_path	
		end
	else
		redirect_to signup_path
	end	
end

end
