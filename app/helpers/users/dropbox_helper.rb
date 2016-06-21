require 'net/http'

module Users::DropboxHelper
    THUMB_MAX_SIZE = 20_000_000 # in bytes

    THUMB_SIZES = {
        w32h32: 'w32h32',
        w64h64: 'w64h64',
        w128h128: 'w128h128',
        w640h480: 'w640h480',
        w1024h768: 'w1024h768'
    }

    FORMATS = {
        jpg: 'jpeg',
        png: 'png'
    }

    def get_temporary_link(data, access_token)
        post_req(
            'https://api.dropboxapi.com/2/files/get_temporary_link',
            data, 
            {
                'Authorization' => 'Bearer ' + access_token, 
                'Content-type' => 'application/json'
            }
        )
    end

    def list_folder(data, access_token)
        post_req(
            'https://api.dropboxapi.com/2/files/list_folder',
            data,
            {
                'Authorization' => 'Bearer ' + access_token, 
                'Content-type' => 'application/json'
            }
        )
    end

    def self.test
        binding.pry
    end

    def self.list_folder_continue(data, access_token)
        post_req(
            'https://api.dropboxapi.com/2/files/list_folder/continue',
            data,
            {
                'Authorization' => 'Bearer ' + access_token, 
                'Content-type' => 'application/json'
            }
        )   
    end

    def get_thumbnail(data, access_token)
        get_req(
            'https://content.dropboxapi.com/2/files/get_thumbnail',
            {
                'Authorization' => 'Bearer ' + access_token, 
                'Dropbox-API-Arg' => data.to_json
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
        end
    end

    def get_thumbnails(entries, access_token)
        entries.map do |entry|
            return nil if entry['size'] >= THUMB_MAX_SIZE

            if (entry['path_lower'] && entry['media_info'] && entry['media_info']['metadata']['.tag'] == 'photo')
                data = get_thumbnail({path: entry['id'], format: FORMATS[:jpg], size: THUMB_SIZES[:w640h480]}, access_token)
                if data.body
                    'data:image/' + FORMATS[:jpg] + ';base64,' + Base64.strict_encode64(data.body)
                else 
                    nil
                end
            else
                nil
            end
        end
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

    def get_req(address, headers)
        uri = URI(address)
        req = Net::HTTP::Get.new(uri)
        headers.each { |name, value| req[name] = value }
        
        res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
            http.request(req)
        end
    end
end
