class FFdevicesController < ApplicationController
  before_action :set_f_fdevice, only: [:show, :edit, :update, :destroy]

  # GET /f_fdevices
  # GET /f_fdevices.json
  def index
    @f_fdevices = FFdevice.all
  end

  # GET /f_fdevices/1
  # GET /f_fdevices/1.json
  def show
  end

  # GET /f_fdevices/new
  def new
    @f_fdevice = FFdevice.new
  end

  # GET /f_fdevices/1/edit
  def edit
  end

  # POST /f_fdevices
  # POST /f_fdevices.json
  def create
    @f_fdevice = FFdevice.new(f_fdevice_params)

    respond_to do |format|
      if @f_fdevice.save
        format.html { redirect_to @f_fdevice, notice: 'F fdevice was successfully created.' }
        format.json { render :show, status: :created, location: @f_fdevice }
      else
        format.html { render :new }
        format.json { render json: @f_fdevice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /f_fdevices/1
  # PATCH/PUT /f_fdevices/1.json
  def update
    respond_to do |format|
      if @f_fdevice.update(f_fdevice_params)
        format.html { redirect_to @f_fdevice, notice: 'F fdevice was successfully updated.' }
        format.json { render :show, status: :ok, location: @f_fdevice }
      else
        format.html { render :edit }
        format.json { render json: @f_fdevice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /f_fdevices/1
  # DELETE /f_fdevices/1.json
  def destroy
    @f_fdevice.destroy
    respond_to do |format|
      format.html { redirect_to f_fdevices_url, notice: 'F fdevice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_f_fdevice
      @f_fdevice = FFdevice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def f_fdevice_params
      params.require(:f_fdevice).permit(:name, :organization_id, :user_id)
    end
end
