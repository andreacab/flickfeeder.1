require 'faye/websocket'

class Shrimp
    # Heroku has a 50 seconds idle connection time limit. 
    KEEPALIVE_TIME = 15 # in seconds
    @@clients = []

    # Instance methods
    def initialize(app)
        @app = app
        @subscribed = false
    end

    def call(env)
        # store the instance for later access
        env['rack.shrimp'] = self
        
        # subscribe to redis channel (it makes sure we subscribe only once)
        message_subscriber

        if Faye::WebSocket.websocket?(env)
            puts "/*** New websocket connection ***/"
            
            # Send every KEEPALIVE_TIME sec a ping for keeping the connection open.
            ws = Faye::WebSocket.new(env, nil, { ping: KEEPALIVE_TIME })

            ws.on :open do |event|
                puts '/*** Websocket OPEN ***/'
                p [[Process.pid], :Shrimp_open, ws.object_id]
                @@clients << ws
            end

            ws.on :message do |event|
                puts '/*** Websocket ON ***/'
                p [[Process.pid], :Shrimp_message, event.data]
                ws.send("World".to_json)
            end

            ws.on :close do |event|
                puts '/*** Websocket CLOSE ***/'
                p [[Process.pid], :Shrimp_close, ws.object_id]
                @@clients.delete(ws)
                ws = nil
            end

            ws.on :error do |event|
                puts '/*** Websocket ERROR ***/'
                p [[Process.pid], :close, ws.object_id, event.code, event.reason]
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

        redis_uri = URI.parse(ENV["REDISCLOUD_URL"])
        
        # Subscribe to the redis channel (work on separate thread)
        Thread.new do
            redis_sub = Redis.new(host: redis_uri.host, port: redis_uri.port, password: redis_uri.password)
            
            # thread blocking operation
            redis_sub.subscribe(ENV["REDIS_CHANNEL"]) do |on|
                @subscribed = true
                p [[Process.pid], :redis_subscribed]

                on.message do |channel, msg|
                    data = JSON.parse(msg)
                    p [[Process.pid], :redis_received_msg, data]

                    # find if user has an opened ws connection
                    client = get_client(data["user_id"])
                    
                    # make sure a ws client was found 
                    if client
                        p [[Process.pid], :Shrimp, "sending message through websocket", data["thumbnail_urls"]]
                        
                        # send all the urls to the user's browser
                        client.send(data["thumbnail_urls"].to_json) 
                    end
                end
            end
        end
    end

    def get_client(user_id)
        @@clients.each do |client|
            
            # need to load session manually as it is loaded lazily in rails
            load_session(client)
            p [[Process.pid], :get_client, "connect client is: ", client.env["rack.session"]["warden.user.user.key"][0][0], "looking for client n°", user_id]
            # once session loaded, use it to retrieve user ids. Return the ws client
            if(client.env["rack.session"]["warden.user.user.key"][0][0] == user_id)
                p [[Process.pid], :get_client, "found client! ", client.env["rack.session"]["warden.user.user.key"][0][0]]
                return client
            end
        end
        nil
    end

    def load_session(client)
        if !client.env["rack.session"].loaded?
            p [[Process.pid], :load_session_init, true]
            client.env["rack.session"][:init] = true
        end
    end

end 