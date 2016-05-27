require 'faye/websocket'

class Shrimp
    # Heroku has a 50 seconds idle connection time limit. 
    KEEPALIVE_TIME = 15 # in seconds

    # Class methods
    def self.has_client(user_id)
        !!@@clients.index { |client| client.env["rack.session"]["warden.user.user.key"][0][0] == user_id } 
    end

    def self.clients
        @@clients
    end

    def self.send_message_to_client(user_id, data)
        Shrimp.find_client(user_id).send(data)
    end

    def self.send_to_all_clients(data)
        @@clients.each { |client| client.send(data) }
    end

    # Instance methods
    def initialize(app)
      @app     = app
      @@clients = []
    end

    def call(env)
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
                @@clients.each { |client| client.send(event.data) }
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
    
    def websocket_string
        "*********************************\n****** I AM A WEBSOCKET!!! ******\n*********************************"
    end

    def self.find_client(user_id)
        @@clients.each do |client|
            if client.env["rack.session"]["warden.user.user.key"][0][0] == user_id
                return client
            end
        end
        nil
    end
end 