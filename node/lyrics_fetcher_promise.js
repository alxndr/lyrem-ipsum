String.prototype.for_url = function() {
  return encodeURIComponent(this).replace('%20','-');
};
var Q = require('q');
var request = Q.denodeify(require('request'));
var $ = require('cheerio');

var fetch_artist_data = function(name) {
  // returns promise
  var deferred = Q.defer();
  var url = 'http://lyrics.wikia.com/api.php?func=getArtist&artist=' + name.for_url() + '&fmt=realjson';

  if (!name || !name.length) {
    deferred.reject('missing name');
    return deferred.promise;
  }

  request(url).then(
    function() { deferred.resolve(JSON.parse(arguments[0][0].body)); },
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

  request('http://lyrics.wikia.com/api.php?artist=' + artist_name.for_url() + '&song=' + song_name.for_url() + '&fmt=realjson').then(
    function() { deferred.resolve(JSON.parse(arguments[0][0].body)); },
    function() { deferred.reject('error getting song data', arguments); }
  );

  return deferred.promise;
};

var fetch_lyrics_data = function(lyrics_url) {
  // returns promise
  var deferred = Q.defer();

  if (!lyrics_url) {
    deferred.reject('missing song lyrics url',lyrics_url);
    return deferred.promise();
  }

  console.log('requesting',lyrics_url);
  request(lyrics_url).then(
    function() {
      console.log('accepting',JSON.parse(arguments[0][0].body));
      deferred.resolve(JSON.parse(arguments[0][0].body));
    },
    function() {
      console.log('error',arguments);
      deferred.reject('error getting lyrics', arguments); }
  );

  return deferred.promise;
};

var extract_lyrics = function(song_something) {
  console.log('extract_lyrics',song_something);
  $.load(song_something); // .css('div.lyricbox/text()').map(&:text)
};

if (exports) {
  exports.fetch_artist_data = fetch_artist_data;
  exports.fetch_song_data = fetch_song_data;
  exports.fetch_lyrics_data = fetch_lyrics_data;
  exports.extract_lyrics = extract_lyrics;
}
