require 'spec_helper'

describe LyricsWiki do

  include LyricsWiki

  describe '#fetch_data_for_artist' do
    it 'gets artist info from lyrics.wikia.com' do
      artist_data = {
        :name => 'Frank Zappa',
        :albums => [
          {
            :album => 'Hot Rats',
            :year => '1969',
            :songs => ['Peaches en Regalia', 'Willie the Pimp']
          }
        ]
      }
      stub_request(:get, 'http://lyrics.wikia.com/api.php?artist=frank%20zappa&fmt=realjson&func=getArtist').to_return(status: 200, headers: {}, body: artist_data)
      pending %Q{Failure/Error: data[:name].should == 'Frank Zappa'\n NoMethodError:\n undefined method `strip' for #<Hash:0x007fd12344d698>}
      fetch_data_for_artist('frank zappa')[:name].should == 'Frank Zappa'
    end
  end

  describe '#get_song_data' do
    it 'gets data from lyrics.wikia.com' do
      song_data = {
        :artist => 'Frank Zappa',
        :song => 'Lucille Has Messed My Mind Up',
        :lyrics => "Lucille\nHas messed my mind up\nBut I still love her\nOh I still love her"
      }
      stub_request(:get, 'http://lyrics.wikia.com/api.php?artist=frank%20zappa&fmt=realjson&song=lucille').to_return(status: 200, headers: {}, body: song_data)
      pending %Q{Failure/Error: get_song_data('frank zappa', 'lucille')['lyrics'].should_include 'Lucille'\n NoMethodError:\n undefined method `strip' for #<Hash:0x007fb390d0ef08>}
      fetch_song_data('frank zappa', 'lucille').keys.should == ['artist', 'song', 'lyrics']
    end
  end

  describe '#fetch_lyrics' do
    it 'pulls lyrics out of get_song_data' do
      self.class.any_instance.stub(fetch_song_data: {
        'artist' => 'Frank Zappa',
        'song' => 'Im the Slime',
        'lyrics' => 'Im the slime oozin out of your tv set'
      })
      pending 'figure out how this stub needs to work'
      fetch_lyrics('frank zappa', 'slime') == 'Im the slime oozin out of your tv set'
    end
  end

end
