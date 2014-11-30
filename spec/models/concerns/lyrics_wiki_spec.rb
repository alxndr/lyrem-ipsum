require 'spec_helper'

describe LyricsWiki do

  include LyricsWiki

  describe '#fetch_song_data' do
    it 'gets data from lyrics.wikia.com' do
      stub_request(
        :get,
        'http://lyrics.wikia.com/api.php?artist=frank%20zappa&fmt=realjson&song=lucille'
      ).to_return(
        status: 200,
        headers: {},
        body: {
          artist: 'Frank Zappa',
          song: 'Lucille Has Messed My Mind Up',
          lyrics: "Lucille\nHas messed my mind up\nBut I still love her\nOh I still love her"
        }.to_json
      )

      expect(fetch_song_data('frank zappa', 'lucille').keys).to eq ['artist', 'song', 'lyrics']
    end
  end

end
