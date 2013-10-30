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
    subject { Artist.new('frank zappa').tap{|fz| Rails.logger.warn "\n\n#random_lyric subject: #{fz.inspect}\n\n"} }

    before do
      subject.instance_variable_set(:@lyrics, %w(mmmm moldy garbage truck))
    end

    describe 'when we should fetch' do
      before do
        Artist.any_instance.stub(:should_fetch_new_lyrics?).and_return true
        Artist.any_instance.stub(:fetch_new_song_lyrics).and_return %w(jamming in joe's garage)
      end

      it 'should return something from new lyrics' do
        expect(%w(jamming in joe's garage)).to include(subject.random_lyric)
      end
    end

    describe 'when we should not fetch' do
      before do
        Artist.any_instance.stub(:should_fetch_new_lyrics?).and_return false
      end

      it 'should sample from existing lyrics' do
        expect(%w(mmmm moldy garbage truck)).to include(subject.random_lyric)
      end
    end

  end

  describe '#should_fetch_new_lyrics?' do
    subject { Artist.new('frank zappa') }

    it 'fetches according to % of songs fetched' do
      pending 'test probability?'
    end
  end

  describe '#lyrem' do
    let(:fz) { Artist.new('frank zappa') }
    let(:list_of_lyrics) { [
      'fringe. I mean that, man.',
      'the way no other lover can.',
      'even if I invaded Nicaragua',
      'and the reason you have not seen her,',
      "one 'n one is eleven!",
      "standin' onna porch of the Lido Hotel",
      "meet me onna corner boy'n don't be late,",
      'or are you seeking entry to engage in criminal or immoral activities?',
      "how'd he get in the show?",
      'replaced by a rash. What?'
    ] }

    before do
      fz.stub(:random_lyric) { list_of_lyrics.sample }
    end

    describe ':phrases' do
      it 'returns n random_lyrics' do
        expect(fz.lyrem(phrases: 3).any?{|phrase| !list_of_lyrics.include? phrase}).to be_false
      end

      describe 'when given a phrase_picker' do
        let(:random_number_picker) { Proc.new{ rand(5) } }

        it 'returns results of calling it' do
          numbers = fz.lyrem(phrases: 10, phrase_picker: random_number_picker)

          expect(numbers.length).to equal 10

          numbers.any?{|number| number < 0 || number > 5 }.should be_false
        end
      end
    end

    describe ':sentences' do
      it 'returns n results of phrase_picker' do
        #expect(fz.lyrem(phrases: 3).any?{|phrase| !list_of_lyrics.include? phrase}).to be_false

        pending 'refactoring lyrem creation'
        sentences = fz.lyrem(sentences: 3)
        puts "sentences: #{sentences.inspect}"
        expect(sentences).to eql lyrics
      end

      it 'capitalizes the first letter' do
        /[a-z]/i.match(fz.lyrem(sentences: 1).first)[0].should match /[A-Z]/
      end

      describe 'when given a phrase_picker' do
        let(:loud_phrases) { list_of_lyrics.map{ |p| p.upcase } }
        let(:loud_phrase_picker) { Proc.new { loud_phrases.sample } }

        it 'returns sentency things made of results of calling it' do
          fz.lyrem(sentences: 10, phrase_picker: loud_phrase_picker).each do |sentence|
            loud_phrases.should include sentence
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
          paragraph.scan(/[.!?]/).count.should > 0
          paragraph.split(' ').length.should >= 6 # 3 sentences w/ 2 words each
          paragraph.should_not include ',. '
          paragraph.should_not include '!. '
          paragraph.should_not include '?. '
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
