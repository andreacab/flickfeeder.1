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

    def get_dropbox_thumbnails
        res = list_folder({ path: "", recursive: true, include_media_info: true }, current_user.dropbox_access_token)
        data = JSON.parse(res.body)
        entries = data['entries']
        cursor = data['cursor']
        puts data
        current_user.update_attributes( dropbox_cursor: cursor ) if cursor

        get_temporary_links(entries, current_user.dropbox_access_token)
    end

end
