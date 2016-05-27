require 'users/dropbox_helper'

class MediasController < ApplicationController
    include Users::DropboxHelper

    def index
        @dropbox_thumbnails = []
        if(hasDropboxAccount?(current_user))
            @dropbox_thumbnails = get_dropbox_thumbnails

        end
	end

    private

    def get_dropbox_thumbnails
        thumbs = []
        res = list_folder({ path: "", recursive: true, include_media_info: true }, current_user.dropbox_access_token)
        entries = JSON.parse(res.body)['entries']
        current_user.dropbox_cursor = JSON.parse(res.body)['cursor']
        current_user.save!

        entries.each do |item|
            if ( item['media_info'] && ( item['media_info']['metadata']['.tag'] == 'photo' ) )
                res = get_temporary_link({path: item['path_lower']}, current_user.dropbox_access_token)
                thumbs.push(JSON.parse(res.body))
            end
        end

        return thumbs
    end

end
