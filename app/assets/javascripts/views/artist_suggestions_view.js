/* global define, clearTimeout, setTimeout */

define(['backbone', 'underscore'], function(Backbone, _) {

  var ARTISTS_BY_ALPHABET = [
    ["Aesop Rock", "Agent Orange", "Aimee Mann", "Al Green", "Alicia Keys", "Ani DiFranco",],
    ["The Beatles", "Beck", "Björk", "Bob Dylan", "Bone Thugs 'n Harmony", "Bruce Springsteen"],
    ["Cake", "Carly Simon", "Carole King", "Cat Stevens", "Cheap Trick", "Creedence Clearwater Revival"],
    ["Damon Albarn", "David Bowie", "Dead Kennedys", "Doc Watson", "Drake"],
    ["Earth Wind and Fire", "Easy E", "Electric Light Orchestra", "Eric Clapton", "Erykah Badu"],
    ["Fishbone", "Fleetwood Mac", "Foreigner", "Frank Sinatra", "Frank Zappa"],
    ["Gilbert and Sullivan", "Grateful Dead", "Greg Brown", "Groundation"],
    ["Hall and Oates", "Handsome Boy Modeling School", "Harry Nilsson", "Herbie Hancock", "The Highwaymen"],
    ["Immolation", "Inspectah Deck", "Iron Butterfly", "Iron Maiden", "Israel Vibration"],
    ["Jay-Z", "Jimi Hendrix", "Joan Baez", "Joanna Newsom", "John Lennon", "Johnny Cash"],
    ["Kaki King", "Kaleidoscope", "Karen O", "Kool and the Gang", "Kraftwerk"],
    ["Lauryn Hill", "LCD Soundsystem", "Led Zeppelin", "Luther Vandross"],
    ["The Magnetic Fields", "Merle Haggard", "Metallica", "Michael Jackson", "Mos Def"],
    ["Nick Cave", "Nina Simone", "Nine Inch Nails", "Notorious B.I.G."],
    ["Oasis", "of Montreal", "Ohio Players", "Old Crow Medicine Show", "Ol' Dirty Bastard"],
    ["Paul Simon", "Pavement", "Pete Seeger", "Phish", "Pink Floyd", "Pixies", "Prince"],
    ["Q-Tip", "Queen", "Queen Latifah", "Quicksilver Messenger Service", "Quimby"],
    ["Radiohead", "The Ramones", "Red Hot Chili Peppers", "R. Kelly", "Rolling Stones"],
    ["Sex Pistols", "Slayer", "Smog", "Spinal Tap", "Stevie Wonder"],
    ["Taj Mahal", "Talking Heads", "Tenacious D", "TLC", "Tom Waits", "Tower of Power"],
    ["UB40", "Umberto Tozzi", "Umphrey's McGee", "Usher"],
    ["Vampire Weekend", "Van Halen", "Vanilla Ice", "Van Morrison", "Velvet Underground"],
    ["Ween", "Weird Al Yankovich", "Wild Beasts", "Woody Guthrie", "Wu-Tang Clan"],
    ["Xiu Xiu", "XTC", "Xzibit"],
    ["Yanni", "Yeah Yeah Yeahs", "Yes", "Yesterday Never Dies", "Yo La Tengo"],
    ["Zach Gill", "Zero Hour", "Zombie Girl"]
  ];

  return Backbone.View.extend({

    events: {
      'focusout #artist': "start_suggestions",
      'focusin  #artist': "pause_suggestions",
      'keydown #artist': "clear_suggestion"
    },

    initialize: function() {
      this.suggestion_index = 0;
    },

    render: function() {
      this.$artist_input = this.$(':text[name="artist"]');
      this.suggest_artist();
      return this;
    },

    clear_suggestion: function() {
      if (this.suggested_name && this.suggested_name === this.$artist_input.val()) {
        this.$artist_input.val("");
      }
      return true;
    },

    is_rotating_artists: true,

    pause_suggestions: function() {
      this.is_rotating_artists = false;
      clearTimeout(this.next_suggestion_timeout_id);
      this.suggested_name = this.$artist_input.prop('placeholder');
      this.$artist_input.val(this.suggested_name);
    },

    schedule_future_new_artist: function(options) {
      if (!options) {
        options = {};
      }
      if (!options.seconds) {
        options.seconds = 5;
      }
      var msec = options.seconds * 1000;
      this.next_suggestion_timeout_id = setTimeout(_.bind(this.suggest_artist, this), msec);
    },

    start_suggestions: function() {
      if (this.is_rotating_artists) {
        return;
      }
      this.is_rotating_artists = true;
      this.schedule_future_new_artist({seconds: 10});
    },

    suggest_artist: function() {
      if (this.is_rotating_artists) {
        if (this.$artist_input.val() === this.suggested_name) {
          this.$artist_input.val("");
        }
        var artist_choices = ARTISTS_BY_ALPHABET[this.suggestion_index];
        this.suggestion_index = (this.suggestion_index >= ARTISTS_BY_ALPHABET.length - 1) ? 0 : this.suggestion_index + 1;
        var artist_name = _.sample(artist_choices);
        this.$artist_input.prop({placeholder: artist_name});
        this.schedule_future_new_artist();
      }
    }

  });

});
