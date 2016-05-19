require 'cloudinary'

class HomepageController < ApplicationController
  before_action :required_user_to_have_organization

	def index
     @events = Event.where(organization_id: current_user.organization_id)
	end

end
