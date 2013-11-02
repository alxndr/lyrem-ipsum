Array.prototype.random = function() {
  return this[ Math.floor(Math.random() * this.length) ]
};

var lf = require('./lyrics_fetcher');

lf.fetch_artist_data('phish')
  .then(function(response) {
    var phish = JSON.parse(response.body);
    var song = phish.albums.random().songs.random();
    lf.fetch_song_data('phish', song);
    debugger;
  }
);

// really though would want to say
// var lyrem;
// Q(function() { lf.fetch_artist_data('phish') })
//   .then_or_whatever(function(response) { return JSON.parse(response.body) })
//   .then(function(artist) { lf.fetch_song_data(artist.name, artist) })

