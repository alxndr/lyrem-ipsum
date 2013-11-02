Array.prototype.random = function() {
  return this[ Math.floor(Math.random() * this.length) ];
};
var lyrics_wiki = require('./lyrics_fetcher_promise');

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

lyrics_wiki.fetch_artist_data('phish').then(function(artist) {
  console.log(artist_name(artist));
  var random_song_names = [1, 2, 3, 4, 5].map(function() { return random_song(artist); });
  return lyrics_wiki.fetch_song_data(artist_name(artist), random_song_names[0]);
}).then(function(song) {
  console.log('"%s"', song_name(song));
  console.log();
  if (song.lyrics.match(/^(Not found|Instrumental)$/)) {
    throw '...no lyrics found';
  }
  return lyrics_wiki.fetch_lyrics(song.url);
}).then(function(lyrics) {
  console.log(lyrics);
}, function(err) {
  console.log('error!', err);
});
