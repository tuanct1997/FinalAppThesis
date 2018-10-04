class Status < ApplicationRecord
  belongs_to :device

  def self.take_last(user_id, home_id, device_id)
  	@status = self.all 
  	@status = @status.where("user_id=? AND home_id =? AND device_id =?", user_id,home_id,device_id)
  	if @status
  		@status.last
  	else
  		render json: @status.errors, status: :unprocessable_entity
  	end
  end
end
