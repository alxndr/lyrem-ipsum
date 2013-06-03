require 'spec_helper'

describe Artist do

  before do
    Artist.any_instance.stub(fetch_data_for_artist: {
      'name' => 'Frank Zappa',
      'albums' => [
        {
          'album' => 'Hot Rats',
          'year' => '1969',
          'songs' => ['Peaches en Regalia', 'Willie the Pimp']
        }
      ]
    })
  end

  describe '#display_name' do
    it 'finds a good name from LyricsWiki' do
      Artist.new('frank zappa').display_name.should == 'Frank Zappa'
    end
  end

  describe '#lyrics' do
    before do
      Artist.any_instance.stub(:get_song_data).and_return({
        'artist' => 'Frank Zappa',
        'song' => 'Lucille Has Messed My Mind Up',
        'lyrics' => "Lucille\nHas messed my mind up\nBut I still love her\nOh I still love her"
      })
    end

    it 'returns an array of lyrics' do
      Artist.new('zappa').lyrics.first.should == 'Lucille'
      Artist.new('zappa').lyrics.last.should == 'Oh I still love her'
    end
  end

end

