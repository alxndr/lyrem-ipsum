/* global define */

define([
  'backbone',
  'views/artist_suggestions_view',
  'spinner'
], function(Backbone, ArtistSuggestionsView, Spinner) {

  return Backbone.View.extend({

    el: 'form',

    events: {
      'submit': 'formSubmitted'
    },

    render: function() {
      this.artist_input_view = new ArtistSuggestionsView({el: this.el});
      this.artist_input_view.render();
      this.$button = this.$('button');
      return this;
    },

    formSubmitted: function() {
      this.$button.prop('disabled', 'disabled');
      new Spinner().spin(this.$el[0]);
      this.artist_input_view.ensure_val();
    }

  });

});
