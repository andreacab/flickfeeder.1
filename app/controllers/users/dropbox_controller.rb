require 'dropbox_sdk'
require 'shrimp'
require 'users/dropbox_helper'

class Users::DropboxController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => [:webhook]
    include Users::DropboxHelper

    def enable
        if Rails.env.production?
            @@flow = DropboxOAuth2Flow.new(ENV["DROPBOX_KEY"], ENV["DROPBOX_SECRET"], 'https://' + ENV["HOST"] + '/dropbox/redirect', session, :dropboxToken)
        else
            @@flow = DropboxOAuth2Flow.new(ENV["DROPBOX_KEY_DEV"], ENV["DROPBOX_SECRET_DEV"], 'http://' + ENV["HOST"] + '/dropbox/redirect', session, :dropboxToken)
        end
        authorize_url = @@flow.start()
        redirect_to(authorize_url)
    end

    def disable
    end

    def redirect
        dropbox_access_token, dropbox_user_id = @@flow.finish(params)
        current_user.update(dropbox_access_token: dropbox_access_token, dropbox_user_id: dropbox_user_id)
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

        return if !params['dropbox'] || !params['dropbox']['delta']
        
        # TODO: logic on a separate thread as we need to respond to the webhook as quickly as possible.
        # Thread.new do
            params['dropbox']['delta']['users'].each do |dropbox_user_id| 
                user = User.find_by(dropbox_user_id: dropbox_user_id.to_s)
                
                if Shrimp.is_client_connected?(user.id)
                    if (user.dropbox_access_token && user.dropbox_cursor)
                        res = list_folder_continue({cursor: user.dropbox_cursor}, user.dropbox_access_token)
                    elsif user.dropbox_access_token
                        res = list_folder({ path: "", recursive: true, include_media_info: true }, user.dropbox_access_token)
                    end
                    
                    user.update_attributes( dropbox_cursor: JSON.parse(res.body)['cursor'] )
                    new_thumbnail_urls = get_temporary_links(JSON.parse(res.body)['entries'], user.dropbox_access_token)

                    Shrimp.send_message_to_client(user.id, new_thumbnail_urls.to_json)
                end
            end
        # end

        render nothing: true
    end
end
