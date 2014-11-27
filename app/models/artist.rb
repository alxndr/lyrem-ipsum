class Artist < ActiveRecord::Base

  include LyricsWiki

  validates :slug, presence: true
  # TODO other validations...

  before_create :setup

  def self.find_or_create(name)
    Artist.find_or_create_by slug: name.to_slug
  end

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
    raise ArgumentError unless config[:how_many] && config[:what]
    phrase_maker = config[:phrase_maker] || method(:random_lyric)

    Array.new(config[:how_many]) do
      content_generation_strategy(config[:what], phrase_maker)
    end
  end

  private

  def setup
    raw_data = fetch_data_for_artist(slug.gsub('-', ' ')) or raise 'artist data not found'
    @data = raw_data
    self.data = @data.to_json
    self.name = @data['artist']
    self.slug = @data['artist'].to_slug
  end

  def content_generation_strategy(what, phrase_maker)
    case what
    when :phrases
      phrase_maker.call

    when :sentences
      phrases = lyrem what: :phrases, how_many: rand(2..5), phrase_maker: phrase_maker
      sentence = phrases.join_after_regex(glue: ', ', regex: /[a-z]/i).capitalize_first_letter.strip
      sentence.gsub!(/[,;:'"-]$/, '')
      sentence += '.' if /[a-z]$/i.match(sentence)
      sentence

    when :paragraphs
      lyrem( what: :sentences, how_many: rand(3..7), phrase_maker: phrase_maker ).join(' ')

    else
      raise ArgumentError.new('Artist#lyrem called with unfamiliar keys')
    end
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
    processed_lyrics.presence
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
    @data ||= JSON.parse(data) # ugh. instances created from db skip the @data assignment in #setup
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
