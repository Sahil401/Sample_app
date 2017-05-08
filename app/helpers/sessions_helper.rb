module SessionsHelper
	def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path ,notice: "Please Sign in."
  end
  end 
	
	def sign_in(user)
			remember_token= User.new_remember_token
			cookies.permanent[:remember_token] = remember_token
			user.update_attribute(:remember_token, remember_token)
			self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
        remember_token = (cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		current_user.update_attribute(:remember_token ,(User.new_remember_token))
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def redirect_back_or(default)
			redirect_to(session[:return_to] || default)
	end

	def store_loaction
		session[:return_to] = request.url if request.get?
	end
end
