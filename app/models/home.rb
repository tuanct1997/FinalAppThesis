class Home < ApplicationRecord
	has_many :rooms
	
	has_many :user_homes
	has_many :users, through: :user_homes

	validates :home_name, uniqueness: true
	
	#has_many :devices
	# has_many :users, through: :devices

	# def create_user_home(User)
	# end

	# def as_json(optional = {})
	# 	super().merge({
	# 		user_homes: self.user_homes
	# 	})
	# end

	def self.all_users_and_role(home_id)
		result = []
		@home = Home.find(home_id)
		result << @home;
		result << []
		@user = @home.users
		@user = @user.each do |u|
			@user_home = UserHome.where("user_id = ? AND home_id =?", u["id"],home_id)
			p u
			@re = []
			@re = @re <<u
			@re1 = @re.dup
            re1 = @re1 << {user: @re, role: @user_home[0]["role"]}
			p "as" 
			 p @re
			result[1] << {user: @re[0], role: @user_home[0]["role"]}
		end
		result
	end

end
