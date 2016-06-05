require 'faye/websocket'

class Shrimp
    # Heroku has a 50 seconds idle connection time limit. 
    KEEPALIVE_TIME = 15 # in seconds
    @@clients = []

    # Shrimp's eigenclass 
    class << self

        def clients
            puts 'NUMBER OF CONNECTED WS CLIENTS: ' + @@clients.size.to_s
            @@clients
        end

        def get_client(user_id)
            # check if user_id is one of the ws clients  
            clients.each do |client|
                # need to load session manually as it is loaded lazily in rails
                load_session(client)
                
                # once session loaded, check with session's user id
                if(client.env["rack.session"]["warden.user.user.key"][0][0] == user_id)
                    return client
                end
            end
            nil
        end

        def load_session(client)
            if !client.env["rack.session"].loaded?
                client.env["rack.session"][:init] = true
            end
        end

        def add_client(client_id)
            $redis.sadd("ws_clients", client_id.to_json)
        end

        def remove_client(client_id)
            $redis.srem("ws_clients", client_id.to_json)
        end

        def client_connected?(client_id)
            $redis.sismember("ws_clients", client_id.to_json)
        end
    end

    # Instance methods
    def initialize(app)
        @app = app
        
        redis_uri = URI.parse(ENV["REDISCLOUD_URL"])
        # work on a separte thread not to block current thread
        Thread.new do
            redis_sub = Redis.new(host: redis_uri.host, port: redis_uri.port, password: redis_uri.password)
            redis_sub.subscribe(ENV["REDIS_CHANNEL"]) do |on| # thread blocking operation
                p [:instance_redis_suscribe, true]
                on.message do |channel, msg|
                    data = JSON.parse(msg)
                    p [:instance_redis_incoming_message, data]
                    p [:clients_size_before, @@clients.size]
                    client = Shrimp.get_client(data["user_id"])
                    p [:clients_size_size, @@clients.size]
                    p [:client_is, client]
                    client.send(data["thumbnail_urls"].to_json)if client
                end
            end
        end
    end

    def call(env)
        env['rack.shrimp'] = self
        if Faye::WebSocket.websocket?(env)
            puts websocket_string
            
            # Send every KEEPALIVE_TIME sec a ping for keeping the connection open.
            ws = Faye::WebSocket.new(env, nil, { ping: KEEPALIVE_TIME })

            ws.on :open do |event|
                puts '***** WS OPEN *****'
                p [:open, ws.object_id]
                Shrimp.clients << ws
            end

            ws.on :message do |event|
                puts '***** WS INCOMING MESSAGE *****'
                p [:message, event.data]
                Shrimp.clients.each { |client| client.send(event.data.to_json) }
            end

            ws.on :close do |event|
                puts '***** WS CLOSE *****'
                p [:close, ws.object_id, event.code, event.reason]
                Shrimp.clients.delete(ws)
                ws = nil
            end

            ws.on :error do |event|
                puts '***** WS ERROR *****'
                p [:close, ws.object_id, event.code, event.reason]
            end 

            # Return async Rack response
            ws.rack_response
        else
            @app.call(env)
        end
    end

    private
    
    def websocket_string
        "*********************************\n****** I AM A WEBSOCKET!!! ******\n*********************************"
    end

end 