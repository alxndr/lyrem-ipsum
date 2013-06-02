require 'spec_helper'

describe Artist do

  context 'valid artist name' do
    before do
      Artist.any_instance.stub(:get_artist_data, {
        artist: "Lorde",
        albums: [
          {
            album: "Other Songs",
            songs: [
              "Royals"
            ]
          }
        ]
      })
    end

    describe '#display_name' do
      it 'finds a good name from LyricsWiki' do
        @artist = Artist.new('lorde')
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

