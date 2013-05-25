class Artist

  def initialize(input)
    raise unless input && input.present?

    @input = input
    #get_data
  end

  def display_name
    @display_name
  end

  #private

  def get_data
    artist_data = HTTParty.get("http://lyrics.wikia.com/api.php?func=getArtist&artist=#{url_encode(@input)}&fmt=json")
    if valid_response?(artist_data) && artist_data.parsed_response['albums'] && artist_data.parsed_response['albums'].present?
      @artist_data = artist_data.parsed_response
      @albums = @artist_data['albums'].map{ |a| a['album'] }
      @songs = @artist_data['albums'].map{ |a| a['songs'] }.flatten.sort.uniq
  #    @songs.each do |song|
  #      song_data = HTTParty.get("http://lyrics.wikia.com/api.php?artist=#{url_encode(display_name)}&song=#{url_encode(song)}&fmt=json")
  #    end
    end
  end

  def url_encode(str)
    ERB::Util.url_encode(str)
  end

  def valid_response?(response)
    return response && response.code == 200 && response.parsed_response && response.parsed_response.present?
  end

end

