/* global define */

define(['backbone', 'views/artist_suggestions_view'], function(Backbone, ArtistSuggestionsView) {

  return Backbone.View.extend({

    el: 'form',

    events: {
      'submit': 'formSubmitted'
    },

    render: function() {
      this.artist_input_view = new ArtistSuggestionsView({el: this.el});
      this.artist_input_view.render();
      return this;
    },

    formSubmitted: function() {
      this.artist_input_view.ensure_val();
    }

  });

});