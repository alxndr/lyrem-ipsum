Array.prototype.random = function() {
  return this[ Math.floor(Math.random() * this.length) ];
};
Array.prototype.times_do = function(callback) {
  return Array.apply(null, Array(this[0])).map(callback); // todo - add i param to callback
};
var lyrics_wiki = require('./lyrics_wiki_proxy');

lyrics_wiki.fetch_artist_data('phish')
  .then(function(artist) { console.log(lyrics_wiki.artist_name(artist)); return lyrics_wiki.pick_n_random_songs(artist, 10); })
  .then(function(songs) {
    console.log('here are ten random songs');
    console.log(songs);
    console.log();
  }, function(err) {
    console.log('error!', err);
  });

lyrics_wiki.fetch_artist_data('phish')
  .then(lyrics_wiki.pick_random_song)
  .then(lyrics_wiki.get_lyrics)
  .then(function(retval) { console.log(retval); }, function(err) { console.log('error!', err); })
;

/*
lyrics_wiki.fetch_artist_data('phish')
  .then(function(artist) { console.log(lyrics_wiki.artist_name(artist)); return lyrics_wiki.pick_n_random_songs(artist, 10); })
  .then(lyrics_wiki.get_lyrics_of_songs)
  .then(function(retval) {
    console.log();
    console.log('done!');
    console.log();
    console.log(retval);
  });
*/
