class StatusController < ApplicationController
	
  before_action :set_status, only: [:show, :update, :destroy]

  # GET /status
  def index
    @status = Status.all

    render json: @status
  end

  # GET /status/1
  def show
    render json: @status
  end




  # POST /status
  def create
    @status = Status.new(status_params)

    if @status.save
      render json: @status, status: :created, location: @status
    else
      render json: @status.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /status/1
  def update
    if @status.update(status_params)
      render json: @status
    else
      render json: @status.errors, status: :unprocessable_entity
    end
  end

  # DELETE /status/1
  def destroy
    @status.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def status_params
      params.require(:status).permit(:device_id, :temperature, :acceleration, :location)
    end
end

