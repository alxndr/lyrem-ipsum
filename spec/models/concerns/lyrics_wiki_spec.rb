require 'spec_helper'

describe LyricsWiki do
  include LyricsWiki

  describe '#fetch_data_for_artist' do
    it 'gets artist info from lyrics.wikia.com' do
      artist_data = {
        parsed_response: {
          'name' => 'Frank Zappa',
          'albums' => [
            {
              'album' => 'Hot Rats',
              'year' => '1969',
              'songs' => ['Peaches en Regalia', 'Willie the Pimp']
            }
          ]
        }
      }
      stub_request(:get, /api\.php/).to_return body: artist_data.to_json
      fetch_data_for_artist('frank zappa').should == artist_data
    end
  end

  describe '#get_song_data' do
    it 'gets data from lyrics.wikia.com' do
      song_data = {
        'artist' => 'Frank Zappa',
        'song' => 'Lucille Has Messed My Mind Up',
        'lyrics' => "Lucille\nHas messed my mind up\nBut I still love her\nOh I still love her"
      }
      stub_request(:get, /api\.php/).to_return body: song_data.to_json
      get_song_data('frank zappa', 'lucille').should == song_data
    end
  end

end

