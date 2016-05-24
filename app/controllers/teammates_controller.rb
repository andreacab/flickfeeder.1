class TeammatesController < ApplicationController

  def index
    @teammates = User.where(organization_id: current_user.organization_id)
  end

  def show
    @teammate = User.find(params[:id])
  end

end
