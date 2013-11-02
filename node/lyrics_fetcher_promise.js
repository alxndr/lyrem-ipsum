var Q = require('q');
var Qrequest = Q.denodeify(require('request'));
var cheerio = require('cheerio');

var parse_json_in_body = function() {
  return JSON.parse(arguments[0][0].body);
};
var request_url_then_resolve_deferred = function(config) {
  Qrequest(config.url).then(
    function() { config.deferred.resolve(config.callback.apply(null, arguments)); },
    function() { config.deferred.reject(config.error, arguments); }
  );
};

var fetch_artist_data = function(name) {
  // returns promise
  var deferred = Q.defer();
  if (!name) {
    deferred.reject('missing name');
    return deferred.promise;
  }

  request_url_then_resolve_deferred({
    url: 'http://lyrics.wikia.com/api.php?func=getArtist&artist=' + name + '&fmt=realjson'
    ,callback: parse_json_in_body
    ,error_message: 'error getting artist data'
    ,deferred: deferred
  });

  return deferred.promise;
};

var fetch_song_data = function(artist_name, song_name) {
  // returns promise
  var deferred = Q.defer();
  if (!artist_name || !artist_name.length || !song_name || !song_name.length) {
    deferred.reject('missing artist name or song name');
    return deferred.promise;
  }

  request_url_then_resolve_deferred({
    url: 'http://lyrics.wikia.com/api.php?artist=' + artist_name + '&song=' + song_name + '&fmt=realjson'
    ,callback: parse_json_in_body
    ,error_message: 'error getting song data'
    ,deferred: deferred
  });

  return deferred.promise;
};

var fetch_lyrics_data = function(lyrics_url) {
  // returns promise
  var deferred = Q.defer();
  console.log('fetch lyrics data');

  if (!lyrics_url) {
    deferred.reject('missing song lyrics url',lyrics_url);
    return deferred.promise;
  }

  request_url_then_resolve_deferred({
    url: lyrics_url
    ,callback: function() {
      var $ = cheerio.load(arguments[0][0].body);
      var $lyrics = $('div.lyricbox');
      var $text_nodes = $lyrics.contents().filter(function() {
        return this['0'].type == 'text';
      });
      console.log('got %d nodes', $text_nodes.length);
      console.log('...',$text_nodes.map(function(_i, node) {
          console.log(node.text()); // not quite yet...
        }));

      return {foo:'bar'};
    }
    ,error_message: 'error getting lyrics data'
    ,deferred: deferred
  },true);

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
