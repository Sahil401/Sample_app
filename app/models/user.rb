class User < ActiveRecord::Base
  has_many :authentications, dependent: :destroy
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id" , dependent: :destroy
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
	before_save {self.email = email.downcase}
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	VALID_REGEX_EXP=/\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i
	validates :email, presence: true, format: {with: VALID_REGEX_EXP},uniqueness: {case_sensetive: false}
	has_secure_password
  attr_accessor :is_twitter
	validates :password, length:{minimum: 6}, on: :create

  def apply_omniauth(omniauth)
  self.email = omniauth['info']['email'] if email.blank?
  self.name = "new" if name.blank?
  self.password = "password"
  self.password_confirmation = "password"
  authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
	
  def User.new_remember_token
		SecureRandom.urlsafe_base64
	end
	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

  def followers_on(date)
    @relation = Relationship.where("followed_id = ? AND (created_at >= ? AND created_at <= ?)",self.id,date.beginning_of_day,date.end_of_day)
    @relation.count
  end

  def tweets(date)
    @tweets = Micropost.where("user_id != ? AND (created_at >= ? AND created_at <= ?)",self.id,date.beginning_of_day,date.end_of_day)
    @tweets.count
  end

  def update_follow!(other_user,date)
    @relation = relationships.find_by(followed_id: other_user.id)
    @relation.update_attributes(created_at: date)
  end

	def feed
     Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

	private

	def create_remember_token
		self.remember_token = User.new_remember_token	
	end
end
