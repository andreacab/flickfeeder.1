require 'users/dropbox_helper'


class MediasController < ApplicationController
    include Users::DropboxHelper

    def index
        @dropbox_thumbnails = []
        if hasDropboxAccount?(current_user)
            @dropbox_thumbnails = get_dropbox_thumbnails
        end
	end

    private

    def get_user_dropbox_entries
        res = list_folder({ path: "", recursive: true, include_media_info: true }, current_user.dropbox_access_token)
        data = JSON.parse(res.body)
        
        cursor = data['cursor'] 
        current_user.update_attributes( dropbox_cursor: cursor ) if cursor

        data['entries']
    end

    def get_dropbox_thumbnails  
        # get all files info from current user
        entries = get_user_dropbox_entries
        binding.pry

        # get thumbnails' base-64 encoded string 
        get_thumbnails(entries, current_user.dropbox_access_token).reject { |base64String| !base64String }
    end

    def get_dropbox_temp_links
        # get all files info from current user
        entries = get_user_dropbox_entries

        # get temporary links of full resolution images
        get_temporary_links(entries, current_user.dropbox_access_token).reject { |url| !url }
    end
end
