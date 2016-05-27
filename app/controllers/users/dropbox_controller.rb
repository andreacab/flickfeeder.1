require 'dropbox_sdk'
require 'shrimp'

class Users::DropboxController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => [:webhook]
    include Users::DropboxHelper

    def self.test
    end

    def enable
        if Rails.env.production?
            @@flow = DropboxOAuth2Flow.new(ENV["DROPBOX_KEY"], ENV["DROPBOX_SECRET"], 'https://' + ENV["HOST"] + '/dropbox/redirect', session, :dropboxToken)
        else
            @@flow = DropboxOAuth2Flow.new(ENV["DROPBOX_KEY_DEV"], ENV["DROPBOX_SECRET_DEV"], 'https://' + ENV["HOST"] + '/dropbox/redirect', session, :dropboxToken)
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
        
        # logic on a separate thread as we need to respond to the webhook as quickly as possible.
        Thread.new do
            new_thumbs = []
            params['dropbox']['delta']['users'].each do |dropbox_user_id| 
                user = User.find_by(dropbox_user_id: dropbox_user_id.to_s)
                
                if (Shrimp.has_client(user.id))
                    if user.dropbox_access_token && user.dropbox_cursor
                        res = list_folder_continue({cursor: user.dropbox_cursor}, user.dropbox_access_token)
                        entries = JSON.parse(res.body)['entries']
                        entries.each do |item|
                            if ( item['.tag'] == 'photo' )
                                data = get_temporary_link({path: item['path_lower']}, current_user.dropbox_access_token)
                                new_thumbs.push(JSON.parse(data.body))
                            end
                        end
                    elsif user.dropbox_access_token
                        res = list_folder({ path: "", recursive: true, include_media_info: true }, user.dropbox_access_token)
                        entries = JSON.parse(res.body)['entries']
                        entries.each do |item|
                            if ( item['media_info'] && ( item['media_info']['metadata']['.tag'] == 'photo' ) )
                                data = get_temporary_link({path: item['path_lower']}, current_user.dropbox_access_token)
                                new_thumbs.push(JSON.parse(data.body))
                            end
                        end
                    end

                    Shrimp.send_message_to_client(user.id, new_thumbs.to_json)
                end
            end
        end

        render nothing: true
    end
end
