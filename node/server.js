function start(route) {
  var http = require('http');
  var url = require('url');
  http.createServer(function(request, response) {
    var parsed_url = url.parse(request.url);
    console.log('Requested: ' + parsed_url.pathname);

    route(parsed_url.pathname);

    response.writeHead(200, {
      'Content-Type': 'text/html',
    });

    response.write('<html><body><h1>yo</h1></body></html>');

    response.end();
  }).listen(8888);

  console.log('server started');
}

exports.start = start;

