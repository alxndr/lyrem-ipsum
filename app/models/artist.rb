class Artist

  include LyricsWiki

  def initialize(input)
    raise 'no input' unless input && input.present?
    # todo - add db backend to store lyric data ()for some set of artists?)
    @artist_data = fetch_data_for_artist(input)
    raise('artist not found') unless @artist_data
  end

  def display_name
    @display_name ||= @artist_data['artist']
  end

  def lyrics
    @lyrics ||= songs_data.map { |song_data|
      #puts '*'*18
      #puts 'lyrics song_data'
      #puts song_data.inspect
      sanitize_and_split_lyrics(song_data['lyrics'])
    }.flatten.reject { |lyric|
      lyric.nil? || lyric.empty?
    }
  end

  #def lyrem
  #  @lyrics.shuffle.join ' '
  #end

  #def phrase
  #  @corpus ||= @lyrics + Array.new(@lyrics.length){LoremIpsum.phrase}
  #  @corpus.sample
  #end

  #def lyrem_ipsum(num_sentences=5)
  #  Array.new(num_sentences) do
  #    LoremIpsum.construct(lambda{phrase}, 2, num_sentences, ', ')
  #  end.map(&:capitalize).join('. ')
  #end

  private

  def albums
    @albums ||= @artist_data['albums']
  end

  def album_names
    @album_names ||= albums.map{ |a| a['album'] }
  end

  def song_names
    @song_names ||= albums.map{ |a| a['songs'] }.flatten.sort.uniq
  end

  def songs_data
    @songs_data ||= song_names.map do |song|
      song_data = get_song_data(display_name, song)
      if song_data && song_data['lyrics']
        song_data
      else
        nil
      end
    end.flatten.compact
  end

  def sanitize_and_split_lyrics(lyrics)
    puts "lyrics: #{lyrics}"
    return nil if lyrics == 'Instrumental'
    sanitized = lyrics.gsub(/\[.*\]/, '').gsub(%r{<[^>]*>.*?<[^>]*>},'')
    split = sanitized.split("\n")
    split.flatten.compact
  end

end

