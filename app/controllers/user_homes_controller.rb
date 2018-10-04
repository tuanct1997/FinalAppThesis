class UserHomesController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register index]
  before_action :set_user_home, only: [:show, :update, :destroy]

  # GET /user_homes
  def index
    
    @user_homes = UserHome.all


    render json: @user_homes
  end

  # GET /user_homes/1
  def show
    render json: @user_home
  end

  def login
    authenticate user_params[:email], user_params[:password]
  end
  #POST /user
  def resigter
    @user = User.new(user_params)
    if @user.save
      response = { message: 'User created successfully'}
      render json: response, status: :created 
     else
      render json: @user.errors, status: :bad
     end 
  end

  # POST /user_homes
  def create
    @user_home = UserHome.new(user_home_params)

    if @user_home.save
      render json: @user_home, status: :created, location: @user_home
    else
      render json: @user_home.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_homes/1
  def update
    if @user_home.update(user_home_params)
      render json: @user_home
    else
      render json: @user_home.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_homes/1
  def destroy
    @user_home.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_home
      @user_home = UserHome.find(params[:id])
    end


    # Only allow a trusted parameter "white list" through.

    def user_params
      params.require(:user).permit(:name, :email, :password, :phone_number)
      
    end

    def user_home_params
      params.require(:user_home).permit(:role, :user_id, :home_id)
    end

    def authenticate(email, password)
      command = AuthenticateUser.call(email, password)
  
      if command.success?
        render json: {
          access_token: command.result,
          message: 'Login Successful'
        }
      else
        render json: { error: command.errors }, status: :unauthorized
      end
     end 
end
