var Q = require('q');
var request = Q.denodeify( require('request') );

String.prototype.for_url = function() {
  return encodeURIComponent(this).replace('%20','-');
};

var fetch_artist_data = function(name) {
  // returns promise
  var deferred = Q.defer();
  var url = 'http://lyrics.wikia.com/api.php?func=getArtist&artist=' + name.for_url() + '&fmt=realjson';

  if (!name || !name.length) {
    deferred.reject(  'missing name' );
  }

  request(url).then(
    function() { deferred.resolve(JSON.parse(arguments[0].toJSON().body)); },
    function() { deferred.reject('error getting artist data', arguments); }
  );

  /*
  request_url_and_resolve_deferred({
    url: url
    ,return_value: function() { JSON.parse(arguments[0].toJSON().body); }
    ,deferred: deferred
    ,error_msg: 'error getting artist data'
  });
  */

  return deferred.promise;
};

var fetch_song_data = function(artist_name, song_name) {
  // returns promise
  var deferred = Q.defer();
  var url = 'http://lyrics.wikia.com/api.php?artist=' + artist_name.for_url() + '&song=' + song_name.for_url() + '&fmt=realjson';

  console.log('fetch_song_data',arguments);
  console.log(url);

  request(url).then(
    function() {
    console.log('accepting',arguments[0]);
    deferred.resolve(JSON.parse(arguments[0].toJSON().body));
  },
    function() { deferred.reject('error getting song data', arguments); }
  );

  return deferred;
};

var fetch_song_lyrics = function(song) {
  // song data structure
  var deferred = Q.defer();

  if (!name || !name.length) {
    deferred.reject('missing song name');
    return deferred.promise;
  }

  //Nokogiri::HTML(Net::HTTP.get(URI(song_data['url']))).css('div.lyricbox/text()').map(&:text)

  console.log(song);

  request(url).then(
    function() {
      deferred.resolve(JSON.parse(arguments[0].toJSON().body));
    },
    function(error) {
      deferred.reject('error getting song data', error);
    }
  );

  return deferred;
};

exports || (exports = {});
exports.fetch_artist_data = fetch_artist_data;
exports.fetch_song_data = fetch_song_data;

