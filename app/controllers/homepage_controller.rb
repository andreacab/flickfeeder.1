require 'cloudinary'

class HomepageController < ApplicationController
  before_action :required_user_to_have_organization

	def index
        @events = Event.where("end_date > ? AND organization_id = ? ", DateTime.now, current_user.organization_id )
        @teammates = User.where(organization_id: current_user.organization_id).where.not(id: current_user.id)
        puts @teammates.inspect
        @statistics = []
	end

end
