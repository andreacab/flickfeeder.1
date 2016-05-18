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

    def post_req(address, data, headers)
        uri = URI(address)
        req = Net::HTTP::Post.new(uri)
        req.body = data.to_json
        headers.each { |name, value| req[name] = value }

        res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(req)
        end
    end

    def hasDropboxAccount?(user)
        !!user.dropbox_access_token
    end
end
