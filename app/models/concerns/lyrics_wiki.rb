module LyricsWiki
  extend ActiveSupport::Concern

  def fetch_data_for_artist(name)
    Rails.logger.debug "LyricsWiki#fetch_data_for_artist(#{name.inspect})"
    raise 'no name given' unless name.present?
    api_response = HTTParty.get("http://lyrics.wikia.com/api.php?func=getArtist&artist=#{LyricsWiki.url_encode(name)}&fmt=realjson")
    if valid_response?(api_response) && has_album_data?(api_response)
      api_response.parsed_response # n.b. parsed_response is something HTTParty gives us ... is that true?
    else
      Rails.logger.warn 'LyricsWiki#fetch_data_for_artist returning nil'
      nil
    end
  end

  def fetch_song_data(artist, song_name)
    Rails.logger.debug "LyricsWiki#fetch_song_data(#{artist.inspect}, #{song_name.inspect})"
    raise 'need artist and song name' unless artist.present? && song_name.present?
    song_data = HTTParty.get("http://lyrics.wikia.com/api.php?artist=#{LyricsWiki.url_encode(artist)}&song=#{LyricsWiki.url_encode(song_name)}&fmt=realjson")
    if valid_response?(song_data)
      song_data
    else
      Rails.logger.warn 'LyricsWiki#fetch_song_data returning nil'
      nil
    end
  end

  def fetch_lyrics(artist, song_name) # returns array of strings, or nil
    Rails.logger.debug "LyricsWiki#fetch_lyrics(#{artist.inspect}, #{song_name.inspect})"
    # no quality checking
    song_data = fetch_song_data(artist, song_name)
    if song_data && song_data['url']
      Nokogiri::HTML(HTTParty.get(song_data['url'])).css('div.lyricbox/text()').map(&:text)
    else
      Rails.logger.warn 'LyricsWiki#fetch_lyrics returning nil'
      nil
    end
  end

  # "private"

  def self.url_encode(str)
    ERB::Util.url_encode(str)
  end

  def valid_response?(response)
    response && response.code == 200
  end

  def has_album_data?(response)
    response &&
      response.parsed_response &&
      response.parsed_response.present? &&
      response.parsed_response['albums'] &&
      response.parsed_response['albums'].present?
  end
end
