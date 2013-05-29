module LyricsWiki
  extend ActiveSupport::Concern

  def get_artist_data
    unless @artist_data
      Rails.logger.info "getting data for #{@input}"
      artist_data = HTTParty.get("http://lyrics.wikia.com/api.php?func=getArtist&artist=#{LyricsWiki.url_encode(@input)}&fmt=json")
      @artist_data = if LyricsWiki.valid_response?(artist_data) && artist_data.parsed_response['albums'] && artist_data.parsed_response['albums'].present?
                       artist_data.parsed_response
                     else
                       nil
                     end
    end
    @artist_data
  end

  def get_song_data(song_name)
    Rails.logger.info "getting data for #{song_name}"
    song_data = HTTParty.get("http://lyrics.wikia.com/api.php?artist=#{LyricsWiki.url_encode(display_name)}&song=#{LyricsWiki.url_encode(song_name)}&fmt=realjson")
    if song_data && song_data['lyrics'] # TODO use valid_response?
      song_data
    else
      nil
    end
  end

  def self.url_encode(str)
    ERB::Util.url_encode(str)
  end

  def self.valid_response?(response)
    return response && response.code == 200 && response.parsed_response && response.parsed_response.present?
  end

end

