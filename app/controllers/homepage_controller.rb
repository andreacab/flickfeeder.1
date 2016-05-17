require 'dropbox_sdk'
require 'users/dropbox_helper'

IMAGE_MIME_TYPE = 'image/jpeg'

class HomepageController < ApplicationController
    include Users::DropboxHelper

	def index
        @dropbox_thumbnails = []
        client = DropboxClient.new(current_user.dropbox_access_token)
        root_metadata = client.metadata('/')
        puts JSON.pretty_generate(root_metadata)
        items = root_metadata['contents']

        items.each do |item|
            if item['mime_type'] == IMAGE_MIME_TYPE 
                res = get_temporary_link(item['path'], current_user.dropbox_access_token)
                @dropbox_thumbnails.push(JSON.parse(res.body))
            elsif item['is_dir']
                res = list_folder({path: item['path'], recursive: true, include_media_info: true}, current_user.dropbox_access_token)
            end
        end
        # render component: 'MediasList', props: { medias: @thumbnails }, class: 'mediasList'
	end

end
