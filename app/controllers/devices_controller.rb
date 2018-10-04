class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :update, :destroy]

 # GET /devices
  def index
    @devices = Device.newest_status_json
    render json: @devices
  end

  # GET /devices/1
  def show
    render json: @device
  end

  ## get /status/identifier/:indetifier_id
  def get_identifier_status
    @device = Device.where("identifier=?", params[:identifier_id])
    if @device
      render json: @device
    else
      render json: @device.errors
    end
  end

  
  # POST /devices
  def create
    @device = Device.new(device_params)

    if @device.save
      render json: @device, status: :created, location: @device
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /devices/1
  def update
    if @device.update(device_params)
      render json: @device
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # DELETE /devices/1
  def destroy
    @device.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def device_params
      params.require(:device).permit(:identifier,:device_name)
    end

    # def device_identifier_params
    #   params.require(:device).permit(:identifier)
    # end
end
