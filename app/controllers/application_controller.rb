class ApplicationController < ActionController::API
	# protect_from_forgery_with: :exception
  require 'cmath'
	before_action :authenticate_request
    attr_reader :current_user
  
    include ExceptionHandler

    


  # [...]
    private
    
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
    
    def authenticate_role(home_id, role)

      @user_home = UserHome.where(user_id: current_user[:id]).where(home_id: home_id)
      p @user_home
      p role
      p @user_home[0]["role"]

      @check = (@user_home[0]["role"] <= role)? true : false
         
    end
    
end
