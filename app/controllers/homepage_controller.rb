class HomepageController < ApplicationController

	def index
        @events = Event.where(organization_id: current_user.organization_id)
	end

end
