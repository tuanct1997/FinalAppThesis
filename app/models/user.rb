class User < ApplicationRecord
	
	validates_presence_of :username, :password , :email, :phone_number
	validates :email, uniqueness: true
	 validates :password, presence: true, on: :create

    has_secure_password validations: true

	has_many :user_homes
	has_many :homes, through: :user_homes

	has_many :rooms, through: :homes

	def self.get_user_homes(user_id)
		@user = User.find(user_id)
		@homes = @user.homes
		@results = []
		@homes.each do |x|
			@user_home = UserHome.where("user_id = ? AND home_id = ?", user_id,x["id"])
			p x
			p @user_home
			@results << {home: x, role: @user_home[0]["role"] }
		end
		@results
	end

	def self.get_all_user_devices(user_id)
		@results = []
		@user = User.find(user_id)
		@homes = @user.homes
		@homes.each do |h|
			@devices = Device.where("home_id = ?", h["id"])
			@devices.each do |d|
				@results << d
			end
			
		end
		@results
	end

	
	# has_many :devices
	# has_many :homes, through: :devices
end
