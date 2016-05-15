require 'dropbox_sdk'

APP_KEY = 'zi4lgaw8hhg902c'
APP_SECRET = 'az9gdeflab6ujwk'

class HomepageController < ApplicationController

    def index
    end

    def dropbox
        @@flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, "http://localhost:3000/dropbox-redirect", session, :dropboxToken)
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
