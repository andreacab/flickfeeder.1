require 'dropbox_sdk'

APP_KEY = 'zi4lgaw8hhg902c'
APP_SECRET = 'az9gdeflab6ujwk'
APP_KEY_DEV = '1qc6db7svbn3cpd'
APP_SECRET_DEV = 'xgdifi9kvxd8yh0'

class Users::DropboxController < ApplicationController
    def enable
        if Rails.env.production?
            @@flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, "https://evening-shelf-81489.herokuapp.com/dropbox/redirect", session, :dropboxToken)
        else 
            @@flow = DropboxOAuth2Flow.new(APP_KEY_DEV, APP_SECRET_DEV, "http://localhost:3000/dropbox/redirect", session, :dropboxToken)
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
        puts "in verify"
        puts "in verify"
        puts "in verify"
        puts "in verify"
        puts "in verify"
        puts "in verify"
        render plain: params[:challenge]
    end

    def webhook
        puts "************ Recieved webhook notification *************"
        puts params
        puts params.inspect
        puts res.body
    end
end
