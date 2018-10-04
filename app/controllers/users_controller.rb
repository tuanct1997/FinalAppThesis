class UsersController < ApplicationController
  
  skip_before_action :authenticate_request, only: %i[login register index]
  before_action :set_user, only: [:show, :update, :destroy, :create_home, :delete_home, :get_home_user,:get_room_home,:test, :add_new_member_home,:get_all_device_info,:get_user_homes]
  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  

  # GET /users/1
  # def show
  #   render json: @user
  # end
  #GET /users/devices
  def get_all_device_info
    # @device = Device.where("user_id = ?",current_user[:id])
    # render json: @device
    @devices = User.get_all_user_devices(current_user[:id])
      render json: @devices
  end
  #GET /users/devices
  # def get_all_user_device
  #   Status.take_last current_user[:id] home
  # end

  #get users/homes
  def get_user_homes
    # @user_homes = UserHome.where("user_id =?",current_user[:id])

    @homes = User.get_user_homes current_user[:id]
    if @homes
      render json:@homes
    else
      render json: @homes.errors
    end
  end

    # POST /register
  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully'}
      render json: response, status: :created 
    else
      render json: @user.errors, status: :bad
    end 
  end



  #POST /login
  def login
    authenticate login_params[:email], login_params[:password]
  end
  

  #POST users/homes
  def get_home_user
    @home = Home.joins(:user_homes).where(user_homes: {user_id: current_user[:id] })
    render json: @home
  end

  #POST users/homes
  def create_home
    @home = Home.new(home_params)
    if @home.save
      @user.homes << @home
      render json: { message: 'home created successfully'}
    else
      render json: @home.errors, status: :bad
    end
  end

  # Post /users/homes/:home_id/rooms
  def create_room_home
    @home = Home.find(params[:home_id])
    @room = Room.new(room_params)
    @home.rooms <<@room 

    if @room.save
      render json: { message: 'room created successfully'}
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  #POST users/user_homes/homes/:home_id
  def add_new_member_home
    if authenticate_role params[:home_id], 1
      @home = Home.find(params[:home_id])

      if @home.save
        @member = User.where("email=?",add_new_menber_home_params[:email])
        p "email"
        p add_new_menber_home_params[:email]
        if @member
          p @member
          p @home
          @member[0].homes << @home
          @user_home = UserHome.where(user_id: @member[0]["id"]).where(home_id: params[:home_id])
          if @user_home
            @user_home[0].update(role: add_new_menber_home_params[:role])
            render json: {message: 'add new member successfully'}
          else 
            render json:@user_home.errors, status: :unprocessable_entity
          end
        
        else
          render json: @member.errors, status: :unprocessable_entity
        end
        
      else 
        render json:@home.errors, status: :unprocessable_entity
      end
    else
      render json: {error: 'permission denied'}
    end
  end

  #POST users/devices/status
  def update_beacon_status 
    @device = Device.find_user_home(update_beacon_status_params[:identifier],@current_user[:id])
    p @device
    if @device
      p update_beacon_status_params[:status]
      p @device[0]["id"].is_a?(Integer)
       #@status = Status.create(device_id: @device["id"],temperature: update_beacon_status_params[:status][:temperature],acceleration: update_beacon_status_params[:status][:acceleration],location: update_beacon_status_params[:status][:location],motion: nil)
       @status = @device[0].statuses.create(update_beacon_status_params[:status])
      #if @status.save
        if fall_detection(@device)
          par = update_beacon_status_params[:status].dup
          par = par.merge({motion: 'fall'})
          @status = @status.update(par)
          if @status
            render json: {message: 'fall'}
          else
            render json: @status.errors, status: :unprocessable_entity
          end
        else
          par = update_beacon_status_params[:status].dup
          par = par.merge({motion: "normal"})
          p par
          @status = @status.update(par)
          if @status
            render json: {message: 'normal'}
          else
            render json: @status.errors, status: :unprocessable_entity
          end
          
        end
         #<< @statuses
        #render json: {message: 'update status successfully'}
      # else
      #   render json: @status.errors, status: :unprocessable_entity
      # end
    else
      render json: device.errors , status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  # PUT /users/user_homes/homes/:home_id
def update_role_user_home
    if authenticate_role params[:home_id], 1
      @home = Home.find(params[:home_id])

      if @home.save
        @member = User.where("email =?" ,add_new_menber_home_params[:email])
        if @member
          @user_home = UserHome.where(user_id: @member["id"]).where(home_id: params[:home_id])
          if @user_home
            @user_home[0].update(role: add_new_menber_home_params[:role])
            render json: {message: 'update  member role successfully'}
          else 
            render json:@user_home.errors, status: :unprocessable_entity
          end
        
        else
          render json: @member.errors, status: :unprocessable_entity
        end
        
      else 
        render json:@home.errors, status: :unprocessable_entity
      end
    else
      render json: {error: 'permission denied'}
    end
  end

 # PATCH/PUT /users/homes/:home_id/devices
  def buy_device
    
    if @device = Device.update_info(current_user[:id],params[:home_id])

      render json: {message: 'bought successfully'}
    else
      render json: @device.errors , status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end
  #DELETE /users/homes/:home_id
  def delete_home
    if authenticate_role params[:home_id], 1
      @home = Home.find(params[:home_id])
      @user.homes.destroy(@home)
      if @home.destroy
        render json: {message: 'home deleted successfully'}
      else
        render json: @home.errors, status: :unprocessable_entity
      end
    else
      render json: {error: 'permission denied'}
    end

  end
    

  #DELETE /users/user_homes/homes/:home_id
  def delete_home_member
    if authenticate_role params[:home_id], 1
      @home = Home.find(params[:home_id])

      if @home.save
        @member = User.where("email =?" ,user_params[:email])
        if @member
          @user_home = UserHome.where(user_id: @member["id"]).where(home_id: params[:home_id])
          if @user_home
            @user_home[0].destroy
            render json: {message: 'deleted  member successfully'}
          else 
            render json:@user_home.errors, status: :unprocessable_entity
          end
        
        else
          render json: @member.errors, status: :unprocessable_entity
        end
        
      else 
        render json:@home.errors, status: :unprocessable_entity
      end
    else
      render json: {error: 'permission denied'}
    end
  end
  
  
#DELETE /logout
def logout
   @current_user = nil;
end

  def test
    render json: @user.rooms
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :password, :email, :phone_number)
    end

    def login_params
      params.require(:user).permit(:email, :password)
    end


    def home_params
      params.require(:home).permit(:home_name, :location)
    end

    def room_params
      params.require(:room).permit(:room_name)
    end

    def add_new_menber_home_params
      params.require(:user_home).permit(:role,:email)
    end

    

    def update_beacon_status_params
      params.require(:device).permit(:identifier,:status =>[:temperature, :acceleration, :location])
    end

    def authenticate(email, password)
      command = AuthenticateUser.call(email, password)

      if command.success?
        render json: {
          access_token: command.result,
          message: 'Login Successfully'
        }
      else
        render json: { error: command.errors }, status: :unauthorized
      end
    end 

    def fall_detection(device)
      @device = device
      
      @array = @device[0].statuses.first(2)
      @arr1 = @array[0][:acceleration].split(";",3)
      @arr2 = @array[1][:acceleration].split(";",3)
      x1 = @arr1[0].to_f
      y1 = @arr1[1].to_f
      z1 = @arr1[2].to_f
      x2 = @arr2[0].to_f
      y2 = @arr2[1].to_f
      z2 = @arr2[2].to_f

      
      @Advm = CMath.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
      @angle = CMath.atan((CMath.sqrt(x1*x1 +z1*z1))/y1)*(180/Math::PI);
      p @Advm
      p @angle
      if @Advm >= 1.4 && @angle >30
        return true
      else
        return false  
      end
    end

    
end

