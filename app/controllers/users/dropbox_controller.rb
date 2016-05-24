require 'dropbox_sdk'

class Users::DropboxController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => [:webhook]
    include Users::DropboxHelper

    def enable
        if Rails.env.production?
            @@flow = DropboxOAuth2Flow.new(ENV["DROPBOX_KEY"], ENV["DROPBOX_SECRET"], "https://flickfeeder.herokuapp.com/dropbox/redirect", session, :dropboxToken)
        else
            @@flow = DropboxOAuth2Flow.new(ENV["DROPBOX_KEY_DEV"], ENV["DROPBOX_SECRET_DEV"], "http://localhost:3000/dropbox/redirect", session, :dropboxToken)
        end
        authorize_url = @@flow.start()
        redirect_to(authorize_url)
    end

    def disable
    end

    def redirect
        access_token, user_id = @@flow.finish(params)
        current_user.update(dropbox_access_token: access_token, dropbox_user_id: user_id)
        flash[:notice] = "Successfully connected to Dropbox"
        redirect_to edit_user_registration_path
    end

    def verify
        render plain: params[:challenge]
    end

    def webhook
        dropbox_signature = request.headers['X-Dropbox-Signature']
        if !is_valid_webhook(request.body.read, dropbox_signature)
            return render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
        end

        puts params.inspect
        binding.pry
        if params['dropbox'] && params['dropbox']['delta']
            params['dropbox']['delta']['users'].each do |user_id| 
                Thread.new do
                    puts "a user's dropbox folder has changed!"
                end
            end
        end

        render nothing: true
    end
end
