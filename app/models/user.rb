class User < ActiveRecord::Base
	before_save {self.email = email.downcase}
	validates :name, presence: true, length: { maximum: 50 }
	VALID_REGEX_EXP=/\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i
	validates :email, presence: true, format: {with: VALID_REGEX_EXP},uniqueness: {case_sensetive: false}
	has_secure_password
	validates :password, length:{minimum: 6}
end