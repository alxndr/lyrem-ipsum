Array.prototype.random = function() {
  return this[ Math.floor(Math.random() * this.length) ];
};
Array.prototype.times_do = function(callback) {
  return Array.apply(null, Array(this[0])).map(callback); // todo - add i param to callback
};
var lyrics_wiki = require('./lyrics_wiki_proxy');

// todo - proper objecty things
function random_song(artist) {
  return artist.albums.random().songs.random();
}
function song_name(song) {
  return song.song;
}
function artist_name(artist) {
  return artist.artist;
}

var pick_random_song = function(artist) {
  console.log(artist_name(artist));
  return lyrics_wiki.fetch_song_data(artist_name(artist), random_song(artist));
};
var pick_n_random_songs = function(artist, n) {
  return [n].times_do(function() { return random_song(artist); });
};
var get_lyrics = function(song) {
  console.log('"%s"', song_name(song));
  console.log();
  if (song.lyrics.match(/^(Not found|Instrumental)$/)) {
    throw '...no lyrics found';
  }
  return lyrics_wiki.fetch_lyrics(song.url);
};

lyrics_wiki.fetch_artist_data('phish')
  .then(function(artist) { console.log(artist_name(artist)); return pick_n_random_songs(artist, 10); })
  .then(function(songs) {
    console.log('here are ten random songs');
    console.log(songs);
    console.log();
  }, function(err) {
    console.log('error!', err);
  });

lyrics_wiki.fetch_artist_data('phish')
  .then(pick_random_song)
  .then(get_lyrics)
  .then(function(retval) { console.log(retval); }, function(err) { console.log('error!', err); })
;
