LI.StaticView = Backbone.View.extend {
  className: 'artist-form'
  events: {
    'click input': 'clicked'
    'submit form': 'submitted'
  }
  initialize: () -> #console.log 'view initialize', @$el
  render: () ->
    console.log 'view render'
    @$artist_name_input = @$('input[name="artist"]')
    @start_placeholder_cycle()
  submitted: () -> debugger
  clicked: () -> debugger
  start_placeholder_cycle: ->
    console.log('start_placeholder_cycle', @$el)
    @interval_id = window.setInterval ->
      @artist_names

  artist_suggestions: {
    A: ['Ani DiFranco', 'Al Green', 'Alicia Keys'],
    B: ['Bone Thugs \'n Harmony', 'Beck', 'Bob Dylan']
Cat Stevens ... Creedence Clearwater Revival
David Bowie ... Doc Watson
Eric Clapton ... Erykah Badu
Frank Zappa ... Fleetwood Mac ... Foreigner
Grateful Dead ... Groundation
Herbie Hancock ... Hall and Oates
Iron Maiden ... Israel Vibration
Johnny Cash ... Jimi Hendrix ... John Lennon ... Joan Baez
Kraftwerk ... Kool and the Gang
Led Zeppelin ... Luther Vandross
Michael Jackson ... Merle Haggard ... Metallica
Notorious BIG ... Nine Inch Nails
Ol' Dirty Bastard
Phish ... Pink Floyd ... Prince ... Paul Simon
Queen
Radiohead ... Rolling Stones ... R Kelly
Sex Pistols ... Stevie Wonder ... Slayer
Tenacious D ... Taj Mahal ... Tower of Power ... TLC
U
Velvet Underground
Ween ... Wu-Tang Clan ... Woody Guthrie
X
Yann Tiersen
Zach Gill
}
}
