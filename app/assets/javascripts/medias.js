// var FFWebsocketManager = (function () {
//     var scheme = 'ws://';
//     var uri = scheme + 'localhost:3000/medias/stream/';
//     var ws = new WebSocket(uri);
//     console.log('[FFWebsocketManager] created a new websocket connection');
    
//     ws.onopen = function (event) {
//         console.log('[FFWebsocketManager] Opeing ws!!');
//         ws.send('[FFWebsocketManager] Can you hear me?', event);
//         // console.log(getCookie('_flickfeeder_session'));
//     };
    
//     ws.onmessage = function (event) {
//         console.log('[FFWebsocketManager] Received a message!', event);
//         console.log(event.data);
//     };

//     ws.onclose = function (event) {
//         console.log('[FFWebsocketManager] Closed...', event);
//     };

//     ws.onerror = function (event) {
//         console.log('[FFWebsocketManager] Error....', event)
//     };

//     return {
//         send: function (message) {
//             console.log('Hello!');
//             ws.send("Hello!");
//         }
//     };
// })();
