require 'spec_helper'

describe LyricsWiki do

  include LyricsWiki

  describe '#fetch_data_for_artist' do
    it 'gets artist info from lyrics.wikia.com' do
      stub_request(
        :get,
        'http://lyrics.wikia.com/api.php?artist=frank%20zappa&fmt=realjson&func=getArtist'
      ).to_return(
        status: 200,
        headers: {},
        body: {
          artist: 'Frank Zappa',
          albums: ['Hot Rats']
        }.to_json
      )

      expect(fetch_data_for_artist('frank zappa')['artist']).to eq 'Frank Zappa'
    end
  end

  describe '#get_song_data' do
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

  describe '#fetch_lyrics' do
    it 'pulls lyrics out of fetch_song_data' do
      self.stub(fetch_song_data: {
        'artist' => 'Frank Zappa',
        'song' => 'Im the Slime',
        'lyrics' => 'Im the slime oozin out of your tv set',
        'url' => 'bar',
      })
      self.stub(valid_response?: true)
      pending 'reassess #fetch_lyrics'

      expect(fetch_lyrics('frank zappa', 'slime')).to eq 'Im the slime oozin out of your tv set'
    end
  end

end
