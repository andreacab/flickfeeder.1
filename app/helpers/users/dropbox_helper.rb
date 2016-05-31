require 'net/http'

module Users::DropboxHelper
    def get_temporary_link(data, access_token)
        res = post_req(
            'https://api.dropboxapi.com/2/files/get_temporary_link',
            data, 
            {
                'Authorization' => 'Bearer ' + access_token, 
                'Content-type' => 'application/json'
            }
        )
    end

    def list_folder(data, access_token)
        res = post_req(
            'https://api.dropboxapi.com/2/files/list_folder',
            data,
            {
                'Authorization' => 'Bearer ' + access_token, 
                'Content-type' => 'application/json'
            }
        )
    end

    def list_folder_continue(data, access_token)
        res = post_req(
            'https://api.dropboxapi.com/2/files/list_folder/continue',
            data,
            {
                'Authorization' => 'Bearer ' + access_token, 
                'Content-type' => 'application/json'
            }
        )
    end

    # entries is data received when accessing dropbox API endpoints list_folder or list_folder_continue 
    def get_temporary_links(entries, access_token)
        entries.map do |entry|
            if (entry['media_info'] && entry['media_info']['metadata']['.tag'] == 'photo')
                data = get_temporary_link({path: entry['path_lower']}, access_token)
                JSON.parse(data.body)['link']
            else
                nil
            end
        end.reject { |path| !path }
    end

    def hasDropboxAccount?(user)
        !!user.dropbox_access_token
    end

    def is_valid_webhook(data, hmac_header)
        digest = OpenSSL::Digest::SHA256.new
        if Rails.env.production?
            calculated_hmac = OpenSSL::HMAC.hexdigest(digest, ENV['DROPBOX_SECRET'], data).strip
        else
            calculated_hmac = OpenSSL::HMAC.hexdigest(digest, ENV['DROPBOX_SECRET_DEV'], data).strip
        end
        calculated_hmac == hmac_header
    end

    private 
    
    def post_req(address, data, headers)
        uri = URI(address)
        req = Net::HTTP::Post.new(uri)
        req.body = data.to_json
        headers.each { |name, value| req[name] = value }

        res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(req)
        end
    end
end
