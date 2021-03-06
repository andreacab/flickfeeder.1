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

        return render nothing: true unless (params['dropbox'] && params['dropbox']['delta'])
        
        # TODO: logic on a separate thread as we need to respond to the webhook as quickly as possible.
        # Thread.new do
            params['dropbox']['delta']['users'].each do |dropbox_user_id| 
                user = User.find_by(dropbox_user_id: dropbox_user_id.to_s)
                
                # As long as Dropbox has more user changes indicated by the key "has_more", make dropbox API calls
                has_more = true
                while has_more

                    # check if we FF has a cursor for that user. If yes no need to request all user's files, only what changed since last time
                    if (user.dropbox_cursor && user.dropbox_access_token)
                        res = list_folder_continue({ cursor: user.dropbox_cursor }, user.dropbox_access_token)
                    elsif user.dropbox_access_token
                        res = list_folder({ path: "", recursive: true, include_media_info: true }, user.dropbox_access_token)
                    end
                    data = JSON.parse(res.body)
                    p [[Process.pid], :dropbox_webhook, "data is: ", data]
                    
                    # retrieve the media uri for each entry
                    new_thumbnail_urls = get_temporary_links(data['entries'], user.dropbox_access_token)
                    
                    # update new cursor
                    user.update_attributes( dropbox_cursor: data['cursor'] )

                    # send message to redis cloud instance 
                    p [[Process.pid], :redis_sent_msg, { user_id: user.id, thumbnail_urls: new_thumbnail_urls }]
                    $redis.publish(ENV["REDIS_CHANNEL"], { user_id: user.id, thumbnail_urls: new_thumbnail_urls }.to_json)

                    has_more = data['has_more']
                end
            end
        # end

        render nothing: true
    end
end
