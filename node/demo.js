require('./toolkit');
var lyrics_wiki = require('./lyrics_wiki_proxy');
/*
lyrics_wiki.fetch_artist_data('phish')
  .then(lyrics_wiki.pick_random_song_name)
  .then(lyrics_wiki.get_lyrics)
  .then(function(retval) { console.log(retval); }, function(err) { console.log('error!', err); })
;
*/
lyrics_wiki.fetch_artist_data('phish')
  .then(function(artist) { console.log(lyrics_wiki.artist_name(artist)); return lyrics_wiki.pick_n_random_song_names(artist, 10); })
  .then(lyrics_wiki.get_lyrics_of_songs)
  .then(function(retval) {
    console.log();
    console.log('done!');
    console.log();
    console.log(retval);
  });
