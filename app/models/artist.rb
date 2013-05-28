class Artist

  def initialize(input)
    raise unless input && input.present?

    @input = input
    get_data
  end

  def display_name
    @artist_data['artist']
  end

  def lyrem
    @lyrics.shuffle.join ' '
  end

  def phrase
    @corpus ||= @lyrics + Array.new(@lyrics.length){LoremIpsum.phrase}
    @corpus.sample
  end

  def lyrem_ipsum(num_sentences=5)
    Array.new(num_sentences) do
      LoremIpsum.construct(lambda{phrase}, 2, num_sentences, ', ')
    end.map(&:capitalize).join('. ')
  end

  private

  def get_data
    puts "getting data for #{@input}"
    artist_data = HTTParty.get("http://lyrics.wikia.com/api.php?func=getArtist&artist=#{url_encode(@input)}&fmt=json")
    if valid_response?(artist_data) && artist_data.parsed_response['albums'] && artist_data.parsed_response['albums'].present?
      @artist_data = artist_data.parsed_response
      puts "found data for #{display_name}"
      @albums = @artist_data['albums'].map{ |a| a['album'] }
      puts "albums: #{@albums.inspect}"
      @songs = @artist_data['albums'].map{ |a| a['songs'] }.flatten.sort.uniq
      @song_data = []
      @lyrics = []
      @songs.each do |song|
        puts "getting data for #{song}"
        song_data = HTTParty.get("http://lyrics.wikia.com/api.php?artist=#{url_encode(display_name)}&song=#{url_encode(song)}&fmt=realjson")
        if song_data && song_data['lyrics']
          @song_data.push song_data
          # @lyrics.push TODO do the sanitizing here
        end
      end
      if @song_data.present?
        @lyrics = @song_data.
          map{ |s_d| sanitize_lyrics(s_d['lyrics']) }.
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

  def sanitize_lyrics(lyric)
    lyric.gsub(/\[.*\]/, '').gsub(%r{<sup>[^<]*</sup>},'').split("\n")
  end
end

