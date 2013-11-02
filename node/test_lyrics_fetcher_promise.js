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

function get_artist(artist_name, callback) {
  lyrics_wiki.fetch_artist_data(artist_name).then(function(response) {
    callback(response);
  });
}
function get_song(artist_name, song_name, callback) {
  lyrics_wiki.fetch_song_data(artist_name, song_name).then(function(response) {
    //console.log('got song',response);
    callback(response);
  });
}
function get_lyrics(lyrics_url, callback) {
  console.log('get_lyrics');
  lyrics_wiki.fetch_lyrics_data(lyrics_url).then(function(response) {
    console.log('get_lyrics callback');
    callback(response);
  })
}

get_artist('phish', function(artist) {
  console.log("Looking at %s", artist_name(artist));
  var random_song_names = [1,2,3,4,5].map(function() { return random_song(artist); });
  console.log('random songs',random_song_names[0]);
  get_song(
    artist_name(artist),
    random_song_names[0],
    function(song) {
      console.log('"%s"', song_name(song));
      console.log('song:',song);
      // abort if song.lyrics = 'Not found' || 'Instrumental'
      get_lyrics(song.url, function(lyrics) {
        console.log('got_lyrics:',typeof lyrics);
        if (typeof lyrics == 'object') {
          console.log(Object.keys(lyrics));
        }
      })
    }
  );
});
