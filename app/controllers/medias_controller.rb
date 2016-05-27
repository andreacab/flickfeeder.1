require 'users/dropbox_helper'

class MediasController < ApplicationController
    include Users::DropboxHelper

    def index
        @dropbox_thumbnails = []
        if(hasDropboxAccount?(current_user))
            puts '0**************************'
            @dropbox_thumbnails = get_dropbox_thumbnails
        end
	end

    private

    def get_dropbox_thumbnails
        puts '1**************************'
        thumbs = []
        res = list_folder({ path: "", recursive: true, include_media_info: true }, current_user.dropbox_access_token)
        puts '2**************************'
        entries = JSON.parse(res.body)['entries']
        puts '3**************************'
        puts res
        # current_user.dropbox_cursor = JSON.parse(res.body)['cursor']
        # puts '4**************************'
        # current_user.save!
        # puts '5**************************'

        # entries.each do |item|
        #     puts '6**************************'
        #     if ( item['media_info'] && ( item['media_info']['metadata']['.tag'] == 'photo' ) )
        #         puts '7**************************'
        #         res = get_temporary_link({path: item['path_lower']}, current_user.dropbox_access_token)
        #         thumbs.push(JSON.parse(res.body))
        #     end
        # end
        # puts '8**************************'

        return thumbs
    end

end
