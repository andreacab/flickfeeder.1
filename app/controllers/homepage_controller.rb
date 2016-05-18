require 'cloudinary'

class HomepageController < ApplicationController

	def index
        # Cloudinary::Uploader.upload('https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg')
        @events = Event.where(organization_id: current_user.organization_id)
	end

end
