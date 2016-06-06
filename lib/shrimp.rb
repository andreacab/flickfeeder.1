require 'faye/websocket'

class Shrimp
    # Heroku has a 50 seconds idle connection time limit. 
    KEEPALIVE_TIME = 15 # in seconds
    @@clients = []

    # Shrimp's eigenclass 
    class << self

        def clients
            @@clients
        end

    end

    # Instance methods
    def initialize(app)
        @app = app
        @subscribed = false
    end

    def call(env)
        # store the instance for later access
        env['rack.shrimp'] = self
        
        # subscribe to redis channel
        message_subscriber

        if Faye::WebSocket.websocket?(env)
            puts websocket_string
            
            # Send every KEEPALIVE_TIME sec a ping for keeping the connection open.
            ws = Faye::WebSocket.new(env, nil, { ping: KEEPALIVE_TIME })

            ws.on :open do |event|
                puts '***** WS OPEN *****'
                p [:open, ws.object_id]
                @@clients << ws
            end

            ws.on :message do |event|
                puts '***** WS INCOMING MESSAGE *****'
                p [:message, event.data]
                @@clients.each { |client| client.send(event.data.to_json) }
            end

            ws.on :close do |event|
                puts '***** WS CLOSE *****'
                p [:close, ws.object_id, event.code, event.reason]
                @@clients.delete(ws)
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

    def message_subscriber
        return nil if @subscribed

        p [:redis_subscribe]
        redis_uri = URI.parse(ENV["REDISCLOUD_URL"])
        # work on a separte thread not to block current thread
        Thread.new do
            redis_sub = Redis.new(host: redis_uri.host, port: redis_uri.port, password: redis_uri.password)
            redis_sub.subscribe(ENV["REDIS_CHANNEL"]) do |on| # thread blocking operation
                @subscribed = true
                
                on.message do |channel, msg|
                    data = JSON.parse(msg)
                    p [:redis_received_msg, data]
                    client = get_client(data["user_id"])
                    p [:redis_sent_to, client]
                    p [:clients_connected, @@clients.size]
                    client.send(data["thumbnail_urls"].to_json) if client
                end
            end
        end
    end

    def get_client(user_id)
        # check if user_id is one of the ws clients  
        p [:get_client, user_id]
        @@clients.each do |client|
            # need to load session manually as it is loaded lazily in rails
            p [:get_client, client]
            load_session(client)
            
            # once session loaded, check with session's user id
            if(client.env["rack.session"]["warden.user.user.key"][0][0] == user_id)
                return client
            end
        end
        nil
    end

    def load_session(client)
        p [:load_session, client.env["rack.session"].loaded?]
        if !client.env["rack.session"].loaded?
            client.env["rack.session"][:init] = true
        end
    end
    
    def websocket_string
        "*********************************\n****** I AM A WEBSOCKET!!! ******\n*********************************"
    end

end 