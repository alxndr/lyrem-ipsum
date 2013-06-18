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

  pending '#lyrics' do
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
      before do
        Artist.any_instance.stub(:rand).and_return(0)
      end

      it 'will fetch new song lyrics' do
        Artist.any_instance.should_receive(:fetch_new_song_lyrics).and_return([:lyrics])
        Artist.new('frank zappa').random_lyric
      end

      it 'returns a lyric' do
        lyrics = %w(jamming in joe's garage)
        Artist.any_instance.stub(:fetch_new_song_lyrics).and_return(lyrics)
        lyrics.should include Artist.new('frank zappa').random_lyric
      end
    end

    pending 'when there are some stored lyrics' do
      before do
        Artist.any_instance.stub(:rand).and_return(0)
      end

      it 'sometimes fetches new song lyrics' do
        Artist.any_instance.should_receive(:fetch_new_song_lyrics)
        Artist.new('frank zappa').random_lyric
        Artist.any_instance.stub(:rand).and_return(1)
        Artist.any_instance.should_not_receive(:fetch_new_song_lyrics)
        Artist.new('frank zappa').random_lyric
      end

      it 'returns a lyric' do
        lyrics = %w(jamming in joe's garage)
        Artist.any_instance.stub(:fetch_new_song_lyrics).and_return(lyrics)
        lyrics.should include Artist.new('frank zappa').random_lyric
      end
    end
  end

  describe '#lyrem' do
    let(:fz) { Artist.new('frank zappa') }
    let(:vocab) { ('a' .. 'z').to_a.reverse }

    before do
      fz.stub(:fetch_new_song_lyrics).and_return(vocab)
    end

    describe ':phrases' do
      it 'returns an array of n strings' do
        phrases = fz.lyrem(:phrases => 3)
        phrases.length.should == 3
        phrases.first.class.should == String
        phrases.each do |phrase|
          vocab.should include phrase
        end
      end
    end

    describe ':sentences' do
      it 'returns an array of n strings' do
        sentences = fz.lyrem(sentences: 5)
        sentences.length.should == 5
        sentences.first.class.should == String
      end
    end

    describe ':paragraphs' do
      it 'returns an array of n strings' do
        paragraphs = fz.lyrem(:paragraphs => 2)
        paragraphs.length.should == 2
        paragraphs.first.class.should == String
        paragraphs.first.split(' ').length.should > 10
      end
    end

    describe 'passed a non-matching key' do
      it 'raises' do
        expect {
          fz.lyrem
        }.to raise_error ArgumentError
        expect {
          fz.lyrem foo: :bar
        }.to raise_error ArgumentError
      end
    end
  end

  describe '#fetch_new_song_lyrics' do
    it 'stores songs it has encountered' do
      pending
    end
  end
end
