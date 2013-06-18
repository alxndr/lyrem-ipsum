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

  describe '#slug' do
    it 'slugifies display_name' do
      Artist.any_instance.stub(:display_name).and_return('Frank Zappa')
      Artist.new('fz').slug.should == 'frank-zappa'
    end

    it 'can speak good human' do
      Artist.any_instance.stub(:display_name).and_return(" THE Mama's & the papas.")
      Artist.new('m&p').slug.should == 'the-mamas-and-the-papas'
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
        phrases = fz.lyrem(phrases: 3)
        phrases.length.should == 3
        phrases.first.class.should == String # fetch_new_song_lyrics.class
        phrases.each do |phrase|
          vocab.should include phrase
        end
      end

      describe 'when given a phrase_picker' do
        let(:numbers) { Proc.new{ rand(5) } }

        it 'returns results of calling it' do
          fz.lyrem(phrases: 10, phrase_picker: numbers).each do |number|
            number.should >= 0
            number.should <= 5
          end
        end
      end
    end

    describe ':sentences' do
      it 'returns an array of n strings' do
        sentences = fz.lyrem(sentences: 5)
        sentences.length.should == 5
        sentences.each do |sentence|
          sentence.class.should == String
          sentence.count(', ').should > 0
          sentence.split(' ').length.should >= 2
        end
      end

      describe 'when given a phrase_picker' do
        let(:numbers) { Proc.new{ rand(5) } }

        it 'returns sentency things made of results of calling it' do
          fz.lyrem(sentences: 10, phrase_picker: numbers).each do |sentence|
            pending 'how to check content'
          end
        end
      end
    end

    describe ':paragraphs' do
      it 'returns an array of n strings' do
        paragraphs = fz.lyrem(paragraphs: 10)
        paragraphs.length.should == 10
        paragraphs.each do |paragraph|
          paragraph.class.should == String
          paragraph.count('.').should > 0
          paragraph.count(',').should >= paragraph.count('.')
          paragraph.split(' ').length.should >= 6 # 3 sentences w/ 2 words each
        end
      end

      describe 'when given a phrase_picker' do
        let(:numbers) { Proc.new{ rand(5) } }

        it 'returns paragraphy things made of sentency things made of results of calling it' do
          fz.lyrem(paragraphs: 10, phrase_picker: numbers).each do |paragraph|
            pending 'how to check content'
          end
        end
      end
    end

    describe 'not passing required key' do
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
