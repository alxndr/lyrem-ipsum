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
  .then(log('artist', function(v) {return lyrics_wiki.artist_name(v);}))
  .then(function(artist) {
    return lyrics_wiki.pick_n_random_song_names(artist, 10); })
  .then(log('song names'))
  .then(lyrics_wiki.get_lyrics_of_songs)
  .then(function(lyrics) {
    console.log('in those ' + lyrics.length + ' random songs');
    var total_lines = lyrics.map(function(r) { return(r.length); }).reduce(function(prev, cur){ return prev + cur;},0);
    console.log('there are ' + total_lines + ' unique* lines');
    return lyrics;
  })
  .done()
;

function log(msg, cb) {
  return function(val) {
    console.log(msg,(typeof cb == 'function') ? cb(val) : val);
    return val;
  };
}
