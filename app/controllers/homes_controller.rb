class HomesController < ApplicationController
  before_action :set_home, only: [:show, :update, :destroy,:get_users_of_home]
  skip_before_action :authenticate_request

  # GET /homes
  def index
    @homes = Home.all

    render json: @homes
  end

  # GET /homes/1
  def show
    render json: @home
  end

  #Get /homes/:id/users
  def get_users_of_home
    # if @home
    #   render json: @home.users
    # else
    #   render json: @home.errors, status: :unprocessable_entity
    # end
    @home = Home.all_users_and_role params[:id]
     if @home
       render json: @home
     else
       render json: @home.errors, status: :unprocessable_entity
     end
  end

  

  # POST /homes
  def create
    @home = Home.new(home_params)

    if @home.save
      render json: @home, status: :created, location: @home
    else
      render json: @home.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /homes/1
  def update
    if @home.update(home_params)
      render json: @home
    else
      render json: @home.errors, status: :unprocessable_entity
    end
  end

  # DELETE /homes/1
  def destroy
    @home.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home
      @home = Home.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def home_params
      params.require(:home).permit(:home_name, :location)
    end

    
end
