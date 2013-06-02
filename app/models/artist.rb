class Artist
  # todo - add db backend to store info for found artists

  include LyricsWiki

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
    begin
      @artist_data ||= get_artist_data
    rescue
      raise 'No good data'
    end
    extract_album_data
    extract_song_data
    @lyrics = []
    @song_data = @songs.map do |song|
      song_data = get_song_data(song)
      if song_data && song_data['lyrics']
        @lyrics.push sanitize_lyrics(song_data['lyrics'])
        song_data
      else
        nil
      end
    end.flatten.compact
  end

  def extract_album_data
    @albums ||= @artist_data['albums'].map{ |a| a['album'] }
  end

  def extract_song_data
    @songs ||= @artist_data['albums'].map{ |a| a['songs'] }.flatten.sort.uniq
  end

  def sanitize_lyrics(lyric)
    lyric.gsub(/\[.*\]/, '').gsub(%r{<[^>]*>.*?<[^>]*>},'').split("\n").flatten.compact.reject{ |l| /Instrumental/.match(l) }
  end

end

