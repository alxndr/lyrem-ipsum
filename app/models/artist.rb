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

  def slug
    @slug ||= display_name.to_slug
  end

  def random_lyric
    @lyrics ||= []
    if should_fetch_new_lyrics?
      new_lyrics = nil
      until new_lyrics && new_lyrics.present?
        new_lyrics = fetch_new_song_lyrics
      end
      @lyrics += new_lyrics
      new_lyrics.sample
    else
      @lyrics.sample
    end.tap{|rv| "random_lyric returning: #{rv.inspect}".colorize :green}
  end

  def should_fetch_new_lyrics?
    return true if @lyrics.length == 0

    if @lyrics.length < 100
      @lyrics.length / 3
    elsif @lyrics.length < 150
      @lyrics.length / 2
    else
      90
    end.percent_of_the_time do
      return false
    end

    true
  end

  def lyrem(opts) # todo - rethink ... separate concern called TextBuilder or something
    phrase_picker = opts[:phrase_picker] || method(:random_lyric) # should be in initialization of separate object

    case opts # these become separate methods

    when hash_has_key?(:phrases)
      Array.new(opts[:phrases]) do
        phrase_picker.call.tap{|c| puts "phrase called: #{c.inspect}"}
      end

    when hash_has_key?(:sentences)
      Array.new(opts[:sentences]) do
        phrases = lyrem(phrases: (rand(3)+2).tap{|np| puts "sentence gonna be made of #{np} phrases"}, phrase_picker: phrase_picker)
        sentence = phrases.join_after_regex(glue: ', ', regex: /[a-z]/i).capitalize_first_letter
        sentence += '.' if /[a-zA-Z]$/.match(sentence)
        sentence
      end

    when hash_has_key?(:paragraphs)
      Array.new(opts[:paragraphs]) do
        lyrem({sentences: rand(5)+3, phrase_picker: phrase_picker}).join(' ')
      end

    else
      raise ArgumentError
    end
  end

  private

  def fetch_new_song_lyrics
    lyrics, i = [], 0
    until lyrics.present? || i > 5
      new_song = pick_new_song.tap{|sn| puts "looking at lyrics for #{sn.inspect}"}
      songs_fetched << new_song
      lyrics = process_lyrics(fetch_lyrics(display_name, new_song))
      i += 1 # TODO better way of covering potential infloop
    end
    lyrics.tap{|l| puts "fetch_new_song_lyrics returning #{l.length} lines"}
  end

  def process_lyrics(lyrics_arr)
    processed_lyrics = sanitize_lyrics(lyrics_arr).keep_if(&:valid_lyric?).uniq
    # todo - uniq against @lyrics
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
    # TODO handle when song lists are the same
    (song_names - songs_fetched).sample
  end

  def percentage_of_songs_fetched
    (songs_fetched.length.to_f / song_names.length.to_f).tap{|pct| puts "% songs fetched: #{pct.round(1)} (#{songs_fetched.length}/#{song_names.length})"}
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

  String.instance_eval do
    include CustomString
  end

  Array.instance_eval do
    include CustomArray
  end

end
