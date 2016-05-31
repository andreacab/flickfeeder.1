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

        def is_client_connected?(user_id)
            client_index = clients.index do |client|
                load_session(client)
                client.env["rack.session"]["warden.user.user.key"][0][0] == user_id
            end
            !!( client_index && ( client_index > -1 ) )
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

        def send_message_to_client(user_id, data)
            get_client(user_id).send(data)
        end

        def send_to_all_clients(data)
            clients.each { |client| client.send(data) }
        end

        def load_session(client)
            if !client.env["rack.session"].loaded?
                client.env["rack.session"][:init] = true
            end
        end

        def say_hi
            puts "HELLO!!!!!!!!!!"
        end
    end

    # Instance methods
    def initialize(app)
      @app = app
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