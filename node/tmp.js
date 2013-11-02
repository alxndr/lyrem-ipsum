request = require('request');
jsdom = require('jsdom');
request(
  'http://lyrem-ipsum.com'
  , function(error, response, body) {
    console.log('first callback');
    console.log('body:',body);
    stuff.status_code = response.statusCode;
    stuff.body = body;
    stuff.jsdom_returnval = jsdom.env({
      html: body,
      done: function() {
        console.log('done');
        stuff.done_arguments = arguments;
      }
    },
    function(error) {
      console.log('error');
      stuff.error = error;
    });
  }
);
