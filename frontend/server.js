var http = require('http');
var os = require("os");
var hostname = os.hostname();

var handleRequest = function(request, response) {
    console.log('Received request for URL: ' + request.url);
    response.writeHead(200);
    console.log(os);
    response.end('Hello Frontend! Work with HOST:'+hostname);
};
var www = http.createServer(handleRequest);
www.listen(8080);
