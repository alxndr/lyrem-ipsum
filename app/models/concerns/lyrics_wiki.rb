module LyricsWiki
  extend ActiveSupport::Concern

  def fetch_data_for_artist(name)
    raise 'no name given' unless name.present?

    api_response = Net::HTTP.get(URI("http://lyrics.wikia.com/api.php?func=getArtist&artist=#{LyricsWiki.url_encode(name)}&fmt=realjson"))

    raise 'invalid response' unless valid_response?(api_response)
    raise 'no albums found' unless has_album_data?(api_response)

    JSON.parse(api_response)
  end

  def fetch_song_data(artist, song_name)
    raise 'need artist and song name' unless artist.present? && song_name.present?

    song_data = Net::HTTP.get(URI("http://lyrics.wikia.com/api.php?artist=#{LyricsWiki.url_encode(artist)}&song=#{LyricsWiki.url_encode(song_name)}&fmt=realjson"))
    raise 'invalid response' unless valid_response?(song_data)

    JSON.parse(song_data)
  end

  def fetch_lyrics(artist, song_name) # returns array of strings, or nil
    # no quality checking
    song_data = fetch_song_data(artist, song_name)
    raise 'invalid response' unless valid_response?(song_data) && song_data['url']

    Nokogiri::HTML(Net::HTTP.get(URI(song_data['url']))).css('div.lyricbox/text()').map(&:text)
  end

  # "private"

  def self.url_encode(str)
    ERB::Util.url_encode(str)
  end

  def valid_response?(response)
    response # TODO fix
  end

  def has_album_data?(response)
    response &&
      response['albums'] &&
      response['albums'].present?
  end
end

