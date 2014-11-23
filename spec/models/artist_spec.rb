require 'spec_helper'

describe Artist do

  subject { FactoryGirl.create :artist }

  describe 'validations' do
    it { is_expected.to validate_presence_of :slug }
  end

  describe '#random_lyric' do
    it 'returns something from @lyrics' do
      pending 'how to test the randomness buried in the math'
      subject.instance_variable_set(:@lyrics, %w(foo bar baz))
      lyric = subject.random_lyric
      expect(%w(foo bar baz)).to contain lyric
    end
  end

  describe '#lyrem' do

    let(:phrases) { [
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
      subject.stub(:fetch_new_song_lyrics).and_return(phrases)
    end

    describe ':phrases' do
      it 'returns an array of n strings' do
        phrases = subject.lyrem(what: :phrases, how_many: 3)
        phrases.length.should == 3
        phrases.first.class.should == String # fetch_new_song_lyrics.class
        phrases.each do |phrase|
          phrases.should include phrase
        end
      end

      describe 'when given a phrase_maker' do
        let(:numbers) { Proc.new { rand(5) } }

        it 'returns results of calling it' do
          subject.lyrem(what: :phrases, how_many: 10, phrase_maker: numbers).each do |number|
            number.should >= 0
            number.should <= 5
          end
        end
      end
    end

    describe ':sentences' do
      it 'returns an array of n strings' do
        sentences = subject.lyrem(what: :sentences, how_many: 5)
        sentences.length.should == 5
        sentences.each do |sentence|
          sentence.class.should == String
          sentence.split(' ').length.should >= 2
          %w(,, ., !, ?, ,. !. ?.).each do |punct_combo|
            sentence.should_not include punct_combo
          end
        end
      end

      it 'capitalizes the first letter' do
        /[a-z]/i.match(subject.lyrem(what: :sentences, how_many: 1).first)[0].should match /[A-Z]/
      end

      describe 'when given a phrase_maker' do
        let(:new_phrases) { phrases.map { |p| p.upcase } }
        let(:phrase_maker) { Proc.new { new_phrases.sample } }

        it 'returns sentency things made of results of calling it' do
          subject.lyrem(what: :sentences, how_many: 10, phrase_maker: phrase_maker).each do |sentence|
            expect(new_phrases.any? { |new_phrase| sentence.include? new_phrase }).to be true
            # could subtract each instance of new_phrases elements from sentence, result should be whitespace?
          end
        end
      end
    end

    describe ':paragraphs' do
      it 'returns an array of n strings' do
        paragraphs = subject.lyrem(what: :paragraphs, how_many: 10)
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

      describe 'when given a phrase_maker' do
        let(:numbers) { Proc.new { rand(5) } }

        it 'returns paragraphy things made of sentency things made of results of calling it' do
          subject.lyrem(what: :paragraphs, how_many: 10, phrase_maker: numbers).each do |paragraph|
            paragraph.length.should > 10
            paragraph.split(' ').each do |number|
              number.to_i.should < 5
            end
          end
        end
      end
    end

    describe 'not passing required key' do
      it 'raises' do
        expect { subject.lyrem }.to raise_error ArgumentError
        expect { subject.lyrem what: :foo }.to raise_error ArgumentError
        expect { subject.lyrem how_many: 13 }.to raise_error ArgumentError
      end
    end
  end

  describe '#setup' do

    describe 'when missing data' do

      before do
        subject.data = nil
      end

      describe 'when artist is found' do

        before do
          allow(subject).to receive(:fetch_data_for_artist).and_return({
            'artist' => 'Foo',
            'albums' => %w(bar baz qux),
          })
          subject.send :setup
        end

        it 'should set name' do
          expect(subject.name).to eq 'Foo'
        end

        it 'should set slug' do
          expect(subject.slug).to eq 'foo'
        end

        it 'should set data' do
          expect(subject.data).to eq({artist: 'Foo', albums: %w(bar baz qux)}.to_json)
        end

      end

      describe 'when artist is not found' do

        before do
          allow(subject).to receive(:fetch_data_for_artist).and_return nil
        end

        it 'should raise' do
          expect{ subject.send :setup }.to raise_error RuntimeError
        end

      end
    end
  end

  describe '.find_or_create' do

    describe 'when artist with that name exists' do
      it 'should return the artist'
    end

    describe 'when artist with that name does not exist' do
      it 'should create a new artist'
    end

  end

end
