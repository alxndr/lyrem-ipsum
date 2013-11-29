class Artist < ActiveRecord::Base

  include LyricsWiki

  after_initialize :get_data

  def random_lyric
    @lyrics ||= []
    if rand((@lyrics.length / 20) + 1).to_i == 0 # TODO make this more clear
      new_lyrics = fetch_new_song_lyrics or return @lyrics.sample
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

  private

  def get_data
    raise 'no name' unless name && name.present?

    @data = fetch_data_for_artist(name) or raise 'artist data not found'
    self.data = @data.to_json
    self.slug = name.to_slug
  end

  def fetch_new_song_lyrics
    # returns nil if no songs left
    lyrics = []
    until lyrics.present?
      new_song = pick_new_song or return nil
      songs_fetched << new_song
      lyrics = process_lyrics(fetch_lyrics(name, new_song))
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
    remaining_songs.sample # nil when no remaining songs
  end

  def remaining_songs
    song_names - songs_fetched
  end

  def songs_fetched # this is a getter and a 'setter'
    @songs_fetched ||= []
  end

  def songs_data
    @songs_data ||= song_names.map do |song|
      song_data = fetch_song_data(name, song)
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
    @albums ||= @data['albums']
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
