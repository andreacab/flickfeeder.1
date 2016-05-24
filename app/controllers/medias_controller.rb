require 'users/dropbox_helper'

class MediasController < ApplicationController
    include Users::DropboxHelper

    def index
        # @dropbox_thumbnails = []
        # if(hasDropboxAccount?(current_user))  name: "dhh",
        #     @dropbox_thumbnails = get_dropbox_thumbnails

        # end
        @medias = Media.all
        @token = Token.new()
        @tokens = Token.where(user_id: current_user.id)

	end

    def new
        @media = Media.new()
    end

    def create
        # @media = Media.new(media_params)
        token = Token.where(token: "passpop").first

        media_params[:url].each do |param|
            current_media = Media.create(url: param, token_id: token.id)
        end
        redirect_to action: "index"
    end

    def show
        @media = Media.find(params[:id])
    end

    private

    def media_params
        params.require(:media).permit(url: [])
    end

    def get_dropbox_thumbnails
        thumbs = []
        res = list_folder({ path: "", recursive: true, include_media_info: true }, current_user.dropbox_access_token)
        items = JSON.parse(res.body)['entries']
        items.each do |item|
            if ( item['media_info'] && ( item['media_info']['metadata']['.tag'] == 'photo' ) )
                res = get_temporary_link({path: item['path_lower']}, current_user.dropbox_access_token)
                thumbs.push(JSON.parse(res.body))
            end
        end

        return thumbs
    end

end
