require('./toolkit');
var Q = require('q');
var Qrequest = Q.denodeify(require('request'));
var cheerio = require('cheerio');

var generic_resolve = function(deferred) {
  return function() {
    deferred.resolve.apply(null,arguments);
  }
};
var generic_reject = function(deferred) {
  return function(error) {
    deferred.reject('error', error);
  }
};

function random_song_name_from_artist(artist) {
  return artist.albums.random().songs.random();
}
function get_song_name(song) {
  return song.song;
}
function artist_name(artist) {
  return artist.artist;
}
var pick_random_song_name = function(artist) {
  return fetch_song_data(artist_name(artist), random_song_name_from_artist(artist));
};
var pick_n_random_song_names = function(artist, n) {
  return [n].times_do(function() {
    return random_song_name_from_artist(artist);
  });
};

var parse_json_in_body = function(response) {
  return JSON.parse(response[0].body);
};
var request_url_then_resolve_deferred = function(config) {
  Qrequest(config.url).then(
    function() {
      config.deferred.resolve(config.callback.apply(null, arguments));
    },
    function() {
      config.deferred.reject(config.error, arguments);
    }
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
    deferred.reject('missing song lyrics url', lyrics_url);
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

var get_lyrics = function(song) {
  console.log('get_lyrics', song);
  console.log('"%s"', get_song_name(song));
  console.log();
  if (!song.lyrics || song.lyrics.match(/^(Not found|Instrumental)$/)) {
    return [''];
  }
  return fetch_lyrics(song.url);
};

var get_lyrics_of_songs = function(songs) {
  console.log('getting lyrics of songs:', songs);

  return Q.all(songs.map(function(song_name) {
    var deferred = Q.defer();
    fetch_song_data('phish', song_name) // todo - how to get artist there
      .then(get_lyrics)
      .then(generic_resolve(deferred), generic_reject(deferred));
    return deferred.promise;
  }));
};

var is_text_node = function(_i, $node) {
  return $node.type == 'text';
};
var get_text = function() {
  return this.text();
};
var extract_lyrics = function(response) {
  var $ = cheerio.load(response[0].body);
  var $contents = $('div.lyricbox').contents();
  var $text_nodes = $contents.filter(is_text_node);
  var dirty_lyrics = $text_nodes.map(get_text);
  return sanitize_lyrics(dirty_lyrics);
};

var trim = function(str) {
  return str.trim();
};
var is_present = function(str) {
  return str.length > 0;
};
var sanitize_lyrics = function(dirty_lyrics) {
  return dirty_lyrics.map(trim).unique().filter(is_present);
};

if (exports) {
  exports.fetch_artist_data = fetch_artist_data;
  exports.fetch_song_data = fetch_song_data;
  exports.fetch_lyrics = fetch_lyrics;
  exports.extract_lyrics = extract_lyrics;
  exports.get_lyrics = get_lyrics;
  exports.get_lyrics_of_songs = get_lyrics_of_songs;
  exports.artist_name = artist_name;
  exports.pick_n_random_song_names = pick_n_random_song_names;
  exports.pick_random_song_name = pick_random_song_name;
}
