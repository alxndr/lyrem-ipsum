var router = require('./router');
var server = require('./server');

server.start(router.route);

