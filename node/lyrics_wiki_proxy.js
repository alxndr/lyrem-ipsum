Array.prototype.unique = function() {
  return this.reduce(function(prev_val, current_val) {
    if (prev_val.indexOf(current_val) < 0) {
      prev_val.push(current_val);
    }
    return prev_val;
  }, []);
};
var Q = require('q');
var Qrequest = Q.denodeify(require('request'));
var cheerio = require('cheerio');

var parse_json_in_body = function(response) { return JSON.parse(response[0].body); };
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

var fetch_lyrics = function(lyrics_url) {
  // returns promise
  var deferred = Q.defer();

  if (!lyrics_url) {
    deferred.reject('missing song lyrics url',lyrics_url);
    return deferred.promise;
  }

  request_url_then_resolve_deferred({
    url: lyrics_url
    ,callback: extract_lyrics
    ,error_message: 'error getting lyrics data'
    ,deferred: deferred
  },true);

  return deferred.promise;
};

var is_text_node = function($node) { return $node.type == 'text'; };
var get_text = function($node) { return $node.text(); };
var extract_lyrics = function(response) {
  return sanitize_lyrics(cheerio.load(response[0].body)('div.lyricbox').contents().filter(is_text_node).map(get_text));
};

var trim = function(str) { return str.trim(); };
var is_present = function(str) { return str.length > 0; };
var sanitize_lyrics = function(dirty_lyrics) {
  return dirty_lyrics.map(trim).unique().filter(is_present);
};

if (exports) {
  exports.fetch_artist_data = fetch_artist_data;
  exports.fetch_song_data = fetch_song_data;
  exports.fetch_lyrics = fetch_lyrics;
  exports.extract_lyrics = extract_lyrics;
}
