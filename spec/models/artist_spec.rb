require 'spec_helper'

describe Artist do

  context 'valid artist name' do
    before do
      Artist.any_instance.should_receive(:get_artist_data).and_return({
        artist: "Lorde",
        albums: [
          {
            album: "Other Songs",
            songs: [
              "Royals"
            ]
          }
        ]
      }.to_json)
      @artist = Artist.new('lorde')
    end

    describe '#display_name' do
      it 'finds a good name from LyricsWiki' do
        @artist.display_name.should == 'Lorde'
      end
    end

  end

  context 'invalid artist name' do

    it 'raises' do
      expect {
        Artist.new('not a legitimate artist')
      }.to raise_error
    end

  end

end

