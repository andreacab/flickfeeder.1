var FFWebsocketManager = (function () {
    var scheme = 'ws://';
    var uri = scheme + 'localhost:3000/medias/stream/';
    var ws = new WebSocket(uri);
    console.log('****** created a new websocket connection');

    ws.onopen = function (event) {
        ws.send('Can you hear me?');
    };
    
    ws.onmessage = function (event) {
        console.log('****** Received a message!');
        console.log(event.data);
    };

    return ws;
})();