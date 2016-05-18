require 'dropbox_sdk'

class Users::DropboxController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => [:webhook]

    def enable
        if Rails.env.production?
            @@flow = DropboxOAuth2Flow.new(DROPBOX_KEY, DROPBOX_SECRET, "https://evening-shelf-81489.herokuapp.com/dropbox/redirect", session, :dropboxToken)
        else 
            @@flow = DropboxOAuth2Flow.new(DROPBOX_KEY_DEV, DROPBOX_SECRET_DEV, "http://localhost:3000/dropbox/redirect", session, :dropboxToken)
        end
        authorize_url = @@flow.start()
        redirect_to(authorize_url)
    end

    def disable
    end

    def redirect
        access_token, user_id = @@flow.finish(params)
        client = DropboxClient.new(access_token)
        current_user.update(dropbox_access_token: access_token, dropbox_user_id: user_id)
        flash[:notice] = "Successfully connected to Dropbox"
        redirect_to edit_user_registration_path
    end

    def verify
        render plain: params[:challenge]
    end

    def webhook
        puts "************ Recieved webhook notification *************"
        puts params
        render nothing: true
    end
end
