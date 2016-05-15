require 'dropbox_sdk'

APP_KEY = 'zi4lgaw8hhg902c'
APP_SECRET = 'az9gdeflab6ujwk'
APP_KEY_DEV = '1qc6db7svbn3cpd'
APP_SECRET_DEV = 'xgdifi9kvxd8yh0'

class HomepageController < ApplicationController

	def index
	end

    def dropbox
        if Rails.env.production?
            @@flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, "https://evening-shelf-81489.herokuapp.com/dropbox-redirect", session, :dropboxToken)
        else 
            @@flow = DropboxOAuth2Flow.new(APP_KEY_DEV, APP_SECRET_DEV, "http://localhost:3000/dropbox-redirect", session, :dropboxToken)
        end
        authorize_url = @@flow.start()
        redirect_to(authorize_url)
    end

    def dropbox_redirect
        access_token, user_id = @@flow.finish(params)
        client = DropboxClient.new(access_token)
        file = open(Rails.root.join("public", "dropbox_test.txt"))
        response = client.put_file('/dropbox_test.txt', file)
        puts "uploaded:", response.inspect
        render nothing: true
    end

    def dropbox_verify
        puts "in verify"
        puts "in verify"
        puts "in verify"
        puts "in verify"
        puts "in verify"
        puts "in verify"
        render plain: params[:challenge]
    end

    def dropbox_webhook
        puts "in webhook"
        puts "in webhook"
        puts "in webhook"
        puts "in webhook"
        puts "in webhook"
        puts "in webhook"
        head :ok
    end
end
