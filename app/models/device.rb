class Device < ApplicationRecord
   belongs_to :user, optional: true
   belongs_to :home, optional: true

   has_many :statuses , -> { order(id: :DESC) }

   validates_presence_of :identifier
   validates :identifier, uniqueness: true
  
  def as_json(option = {})
     p super()
     p self
     super().merge({
       statuses: self.statuses.first,
     })
  end

  
  
    
  

  # def self.newest_status_json()
  #   # p self.all
  #   # p self.all.as_json
  #   p 123
  #   results = []
  #   @device = self.all
  #   @device = @device.each do |t| 
  #      results <<  {device: t, statuses: t.statuses.first}
  #      # results <<  t
  #      # t = t.as_json.merge({
  #      #    statuses: t.statuses.first,
  #      #  })
      
  #      # @result.merge(t.as_json)
  #      #  p @result
  #   end
  #   p results
  #   results
  # end



  def self.update_info(user_id,home_id)
  	@devices = self.all
    @devices = @devices.where(user_id: nil).limit(1)
    
    p @devices
    @status = Status.create(device_id: @devices[0]["id"], temperature: "none", acceleration: "0.00;0.00;0.00", location: "none")
    @device = @devices.update_all(user_id: user_id, home_id: home_id)
  end

  def self.find_user_home(identifier,user_id)
  	@device = self.all 
  	
  	
  	@device.where("identifier = ?  AND user_id = ?",identifier, user_id)
  end

 

end
