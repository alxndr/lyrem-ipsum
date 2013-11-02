var Q = require('q');
var request = Q.denodeify( require('request') );

var fetch_artist_data = function(name) {
  if (!name || !name.length) {
    throw 'missing name';
  }
  var url = 'http://lyrics.wikia.com/api.php?func=getArtist&artist=' + name + '&fmt=realjson';

  return request(url).then(function(response) {
    console.log('then callback');
    if (response.statusCode >= 300) {
      throw 'server returned code ' + response.statusCode;
    }
    return response['0'];
  });
};

var fetch_song_data = function(artist, song) {
};

exports || (exports = {});
exports.fetch_artist_data = fetch_artist_data;
exports.fetch_song_data = fetch_song_data;

