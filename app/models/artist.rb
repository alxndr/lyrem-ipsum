class Artist

  include LyricsWiki

  def initialize(input)
    raise 'no input' unless input && input.present?
    # todo - add db backend to store lyric data (for some set of artists?)
    @artist_data = fetch_data_for_artist(input) # be nice to use HashWithIndifferentAccess
    raise('artist not found') unless @artist_data
  end

  def display_name
    @display_name ||= @artist_data['artist']
  end

  def lyrics
    @lyrics ||= songs_data.map { |song_data|
      sanitize_and_split_lyrics(song_data['lyrics'])
    }.flatten.reject { |lyric|
      lyric.nil? || lyric.empty?
    }
  end

  def random_lyric
    @lyrics ||= []
    if rand((@lyrics.length / 20) + 1).to_i == 0 # TODO make this more clear
      new_lyrics = fetch_new_song_lyrics
      if new_lyrics
        @lyrics += new_lyrics
        # returning here so we'll always get lyrics from a just-downloaded song
        return new_lyrics.sample
      end
    end
    @lyrics.sample
  end

  def lyrem(opts)
    case opts
      when hash_has_key?(:paragraphs)
        'paragraphs'
      when hash_has_key?(:sentences)
        'sentences'
      when hash_has_key?(:phrases)
        'phrases'
      else
        raise ArgumentError
    end
  end

  private

  String.instance_eval do
    define_method('valid_lyric?') do
      self &&
        self.present? &&
        self =~ /[a-z]/i &&
        self !~ /(not found|instrumental|transcribed|copyright)/i
    end
  end

  def fetch_new_song_lyrics
    lyrics, new_song = nil, nil
    unless lyrics.present?
      new_song = get_new_song
      return nil unless new_song
      lyrics = process_lyrics(fetch_lyrics(display_name, new_song))
    end
    songs_fetched << new_song
    lyrics
  end

  def process_lyrics(lyrics_str)
    sanitize_lyrics(lyrics_str.split("\n")).keep_if(&:valid_lyric?)
  end

  def sanitize_lyrics(lyrics_arr)
    lyrics_arr.map{ |lyric| lyric.gsub(/\[.*\]/, '').gsub(%r{<[^>]*>.*?<[^>]*>},'') }
  end

  def get_new_song
    (song_names - songs_fetched).sample #or raise 'no song'
  end

  def songs_fetched # this is a getter and a 'setter'
    @songs_fetched ||= []
  end

  def songs_data
    @songs_data ||= song_names.map do |song|
      song_data = fetch_song_data(display_name, song)
      if song_data && song_data['lyrics']
        song_data
      else
        nil
      end
    end.flatten.compact
  end

  def song_names
    @song_names ||= albums.map{ |a| a['songs'] }.flatten.sort.uniq
  end

  def albums
    @albums ||= @artist_data['albums']
  end

  def album_names
    @album_names ||= albums.map{ |a| a['album'] }
  end

  def hash_has_key?(key)
    lambda { |hash| hash.has_key? key }
  end

end
