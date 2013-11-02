Array.prototype.random = function() {
  return this[ Math.floor(Math.random() * this.length) ];
};

var lfp = require('./lyrics_fetcher_promise');

// todo - proper objecty things
function random_album(artist) {
  return artist.albums.random();
}
function random_song(artist) {
  return artist.albums.random().songs.random();
}
function album_name(album) {
  return album.album;
}
function song_name(song) {
  return song; // bare strings
}
function artist_name(artist) {
  return artist.artist;
}

function get_artist(artist_name, callback) {
  lfp.fetch_artist_data(artist_name).then(function(response) {
    callback(response);
  });
};
function get_song(artist_name, song_name, callback) {
  console.log('get_song');
  lfp.fetch_song_data(artist_name, song_name).then(function(response) {
    console.log('got song',response)
    callback(response);
  });
};
get_artist('phish', function(artist) {
  console.log(artist_name(artist));
  var random_songs = [1,2,3,4,5].map(function() { return random_song(artist); });
  console.log('5 random songs:', random_songs);
  get_song(
    artist_name(artist),
    song_name(random_song(artist)),
    function(response) {
      console.log('get_song callback got passed a', typeof response);
      debugger;
    }
  );
});


