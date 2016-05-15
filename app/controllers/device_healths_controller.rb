class DeviceHealthsController < ApplicationController
  before_action :set_device_health, only: [:show, :edit, :update, :destroy]

  # GET /device_healths
  # GET /device_healths.json
  def index
    @device_healths = DeviceHealth.all
  end

  # GET /device_healths/1
  # GET /device_healths/1.json
  def show
  end

  # GET /device_healths/new
  def new
    @device_health = DeviceHealth.new
  end

  # GET /device_healths/1/edit
  def edit
  end

  # POST /device_healths
  # POST /device_healths.json
  def create
    @device_health = DeviceHealth.new(device_health_params)

    respond_to do |format|
      if @device_health.save
        format.html { redirect_to @device_health, notice: 'Device health was successfully created.' }
        format.json { render :show, status: :created, location: @device_health }
      else
        format.html { render :new }
        format.json { render json: @device_health.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /device_healths/1
  # PATCH/PUT /device_healths/1.json
  def update
    respond_to do |format|
      if @device_health.update(device_health_params)
        format.html { redirect_to @device_health, notice: 'Device health was successfully updated.' }
        format.json { render :show, status: :ok, location: @device_health }
      else
        format.html { render :edit }
        format.json { render json: @device_health.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /device_healths/1
  # DELETE /device_healths/1.json
  def destroy
    @device_health.destroy
    respond_to do |format|
      format.html { redirect_to device_healths_url, notice: 'Device health was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device_health
      @device_health = DeviceHealth.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_health_params
      params.require(:device_health).permit(:current_battery_charge, :f_fdevice_id, :available_storage, :health, :network_signal, :available_mobile_data, :user_id)
    end
end
