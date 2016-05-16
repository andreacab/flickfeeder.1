require 'dropbox_sdk'

class HomepageController < ApplicationController

	def index
        client = DropboxClient.new(current_user.dropbox_access_token)
        root_metadata = client.metadata('/')
        puts "metadata", JSON.pretty_generate(root_metadata)       
        binding.pry
        
        # if root_metadata.contents
        #     thumbnails = root_metadata.contents.map do | content |
        #         if !content.is_dir
        #             client.thumbnail(content.path, "s")
        #         end
        #     end
        # end

        render component: 'MediasList', props: { medias: @thumbnails }, class: 'mediasList'
	end

end
