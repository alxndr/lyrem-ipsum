require 'spec_helper'

describe Artist do

  before do
    Artist.any_instance.stub(fetch_data_for_artist: { # todo stub request? or is that LyricsWiki's job?
      # httparty responses have string keys
      'artist' => 'Frank Zappa',
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
      Artist.any_instance.stub(:fetch_song_data).and_return({ # todo stub request?
        # httparty responses have string keys
        'artist' => 'Frank Zappa',
        'song' => 'Lucille Has Messed My Mind Up',
        'lyrics' => "Lucille\nHas messed my mind up\nBut I still love her\nOh I still love her"
      })
    end

    it 'returns an array of lyrics' do
      a = Artist.new('frank zappa')
      a.lyrics.first.should == 'Lucille'
      a.lyrics.last.should == 'Oh I still love her'
    end
  end

  describe '#random_lyric' do
    describe 'when there are no stored lyrics' do
      it 'will fetch new song lyrics' do
        pending
      end

      it 'returns a lyric' do
        pending
      end
    end

    describe 'when there are some stored lyrics' do
      it 'sometimes fetches new song lyrics' do
        pending
      end

      it 'returns a lyric' do
        pending
      end
    end
  end

end
