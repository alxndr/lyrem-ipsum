require 'spec_helper'

describe LyricsWiki do
  include LyricsWiki

  describe '#get_artist_data' do
    it 'gets data from lyrics.wikia.com' do
      @input = 'frank zappa'
      pending 'stub out HTTParty'
      get_artist_data.should == 'data about frank zappa'
    end

    it 'returns artist data' do
      @artist_data = 'foo' # smelly
      get_artist_data.should == 'foo'
    end
  end

  describe '#get_song_data' do
    it 'gets data from lyrics.wikia.com' do
      @artist_name = 'zappa' # smelly
      pending 'stub out HTTParty'
      get_song_data('billy the mountain').should == {song: awesome}
    end
  end
end

