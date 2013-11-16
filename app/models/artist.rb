class Artist

  include LyricsWiki

  def initialize(input)
    input.gsub! '-', ' '
    input.strip!

    @artist_name = Artist.find_artist_name(input)

    raise 'no artist_name' unless @artist_name && @artist_name.present?

    @artist_data = fetch_data_for_artist(@artist_name)

    raise 'artist not found' unless @artist_data
  end

  def display_name
    @artist_name
  end

  def slug
    @slug ||= display_name.to_slug
  end

  def random_lyric
    @lyrics ||= []
    if rand((@lyrics.length / 20) + 1).to_i == 0 # TODO make this more clear
      new_lyrics = nil
      until new_lyrics && new_lyrics.present?
        new_lyrics = fetch_new_song_lyrics
      end
      @lyrics += new_lyrics
      new_lyrics.sample
    else
      @lyrics.sample
    end
  end

  def lyrem(config)
    phrase_picker = config[:phrase_picker] || method(:random_lyric)

    case true

    when config.has_key?(:phrases)
      Array.new(config[:phrases]) do
        phrase_picker.call
      end

    when config.has_key?(:sentences)
      Array.new(config[:sentences]) do
        phrases = lyrem phrases: rand(3)+2, phrase_picker: phrase_picker
        sentence = phrases.join_after_regex(glue: ', ', regex: /[a-z]/i).capitalize_first_letter.strip
        sentence += '.' if /[a-z]$/i.match(sentence)
        sentence
      end

    when config.has_key?(:paragraphs)
      Array.new(config[:paragraphs]) do
        lyrem({sentences: rand(5)+3, phrase_picker: phrase_picker}).join(' ')
      end

    else
      raise ArgumentError.new('Artist#lyrem called with unfamiliar keys')
    end
  end

  def self.find_artist_name(input)
    result = Google::Search::Web.new(query: "#{input} musician site:en.wikipedia.org").first
    unless result && result.title
      raise 'artist name not found'
    end
    result.title.chomp(' - Wikipedia, the free encyclopedia')
  end


  private


  def fetch_new_song_lyrics
    lyrics, i = [], 0
    until lyrics.present? || i > 5
      new_song = pick_new_song
      songs_fetched << new_song
      lyrics = process_lyrics(fetch_lyrics(display_name, new_song))
      i += 1 # TODO better way of covering potential infloop
    end
    lyrics
  end

  def process_lyrics(lyrics_arr)
    processed_lyrics = sanitize_lyrics(lyrics_arr).keep_if(&:valid_lyric?).uniq
    if processed_lyrics && processed_lyrics.present?
      processed_lyrics
    else
      nil
    end
  end

  def sanitize_lyrics(lyrics_arr)
    lyrics_arr.map{ |lyric|
      lyric.gsub(/\[.*\]/, '').gsub(%r{<[^>]*>.*?</[^>]*>}, '').gsub(/<[^>]*>/, '').strip
    }
  end

  def pick_new_song
    raise 'no remaining songs (or none fetched)' unless (song_names - songs_fetched).present?

    (song_names - songs_fetched).sample
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

  String.instance_eval do
    include CustomString
  end

  Array.instance_eval do
    include CustomArray
  end

end
