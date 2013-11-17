window.LI = Backbone.View.extend {
  initialize: () ->
    console.log 'initialize', @$el
    @artist_form_view = new LI.StaticView {el: '.artist-form'}
    @artist_form_view.render()
    @
}
