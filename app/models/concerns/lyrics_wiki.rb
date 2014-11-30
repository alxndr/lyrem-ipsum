module LyricsWiki
  extend ActiveSupport::Concern

  def fetch_song_data(artist, song_name)
    raise 'need artist and song name' unless artist.present? && song_name.present?
    Rails.logger.info "Using Lyriki version: #{Lyriki::VERSION}"
    Lyriki::Legacy::SongData.new(artist: artist, song: song_name).response_data
  end

end
