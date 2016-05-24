class TeammatesController < ApplicationController

  def index
    @teammates = User.where(organization_id: current_user.organization_id)
  end

  def show
    @user = User.find(params[:id])
  end

end
