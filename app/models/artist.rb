class Artist

  def initialize(input)
    raise unless input && input.present?

    @input = input
    get_data
  end

  def display_name
    @display_name ||= @artist_data['artist']
  end

  def lyrem
    @lyrics.shuffle.join ' '
  end

  private

  def get_data
    artist_data = HTTParty.get("http://lyrics.wikia.com/api.php?func=getArtist&artist=#{url_encode(@input)}&fmt=json")
    if valid_response?(artist_data) && artist_data.parsed_response['albums'] && artist_data.parsed_response['albums'].present?
      @artist_data = artist_data.parsed_response
      @albums = @artist_data['albums'].map{ |a| a['album'] }
      @songs = @artist_data['albums'].map{ |a| a['songs'] }.flatten.sort.uniq
      @song_data = []
      @songs.each do |song|
        song_data = HTTParty.get("http://lyrics.wikia.com/api.php?artist=#{url_encode(display_name)}&song=#{url_encode(song)}&fmt=realjson")
        if song_data && song_data['lyrics']
          @song_data.push song_data
        end
      end
      if @song_data.present?
        @lyrics = @song_data.
          map{ |s_d|
            s_d['lyrics'].
              gsub('[...]', '').
              gsub(%r{<sup>[^<]*</sup>},'').
              split("\n")
          }.
          flatten.
          reject{ |l| l.empty? || /Instrumental/.match(l) }
      end
    else
      raise 'No good data'
    end
  end

  def url_encode(str)
    ERB::Util.url_encode(str)
  end

  def valid_response?(response)
    return response && response.code == 200 && response.parsed_response && response.parsed_response.present?
  end

end

