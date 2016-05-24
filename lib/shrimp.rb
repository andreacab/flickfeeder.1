require 'faye/websocket'

class Shrimp
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app     = app
      @clients = []
    end

    def call(env)
        if Faye::WebSocket.websocket?(env)
            # WebSockets logic goes here
            puts websocket_string
            # Return async Rack response
            ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })

            ws.on :open do |event|
                puts '***** WS OPEN *****'
              p [:open, ws.object_id]
              @clients << ws
            end

            ws.on :message do |event|
                puts '***** WS INCOMING MESSAGE *****'
              p [:message, event.data]
              @clients.each { |client| client.send(event.data) }
            end

            ws.on :close do |event|
                puts '***** WS CLOSE *****'
                p [:close, ws.object_id, event.code, event.reason]
                @clients.delete(ws)
                ws = nil
            end

            ws.on :error do |event|
                puts '***** WS ERROR *****'
                p [:close, ws.object_id, event.code, event.reason]
            end 
            
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