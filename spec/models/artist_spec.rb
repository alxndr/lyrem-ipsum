require 'spec_helper'

describe Artist do

  subject { FactoryGirl.create :artist }

  describe '#random_lyric' do
    it 'returns something from @lyrics' do
      subject.send :load_data
      subject.instance_variable_set(:@lyrics, %w(foo bar baz))
      expect(%w(foo bar baz)).to include subject.random_lyric
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
      allow(subject).to_receive(:fetch_new_song_lyrics).and_return(phrases)
    end

    describe ':phrases' do
      it 'returns an array of n strings' do
        phrases = subject.lyrem(what: :phrases, how_many: 3)
        expect(phrases.length).to eq 3
        expect(phrases.first.class).to eq String # fetch_new_song_lyrics.class
        phrases.each do |phrase|
          expect(phrases).to include phrase
        end
      end

      describe 'when given a phrase_maker' do
        let(:numbers) { Proc.new { rand(5) } }

        it 'returns results of calling it' do
          subject.lyrem(what: :phrases, how_many: 10, phrase_maker: numbers).each do |number|
            expect(number).to be >= 0
            expect(number).to be <= 5
          end
        end
      end
    end

    describe ':sentences' do
      it 'returns an array of n strings' do
        sentences = subject.lyrem(what: :sentences, how_many: 5)
        expect(sentences.length).to eq 5
        sentences.each do |sentence|
          expect(sentence.class).to eq String
          expect(sentence.split(' ').length).to be >= 2
          %w(,, ., !, ?, ,. !. ?.).each do |punct_combo|
            expect(sentence).to_not include punct_combo
          end
        end
      end

      it 'capitalizes the first letter' do
        something = /[a-z]/i.match(subject.lyrem(what: :sentences, how_many: 1).first)[0]
        expect(something).to match(/[A-Z]/)
      end

      describe 'when given a phrase_maker' do
        let(:new_phrases) { phrases.map { |p| p.upcase } }
        let(:phrase_maker) { Proc.new { new_phrases.sample } }

        it 'returns sentency things made of results of calling it' do
          subject.lyrem(what: :sentences, how_many: 10, phrase_maker: phrase_maker).each do |sentence|
            expect(new_phrases.any? { |new_phrase| sentence.include? new_phrase }).to be == true
          end
        end
      end
    end

    describe ':paragraphs' do
      it 'returns an array of n strings' do
        paragraphs = subject.lyrem(what: :paragraphs, how_many: 10)
        expect(paragraphs.length).to eq 10
        paragraphs.each do |paragraph|
          expect(paragraph.class).to eq String
          expect(paragraph.scan(/[.!?]/).count).to be > 0
          expect(paragraph.split(' ').length).to be >= 6 # 3 sentences w/ 2 words each
          expect(paragraph).to_not include ',. '
          expect(paragraph).to_not include '!. '
          expect(paragraph).to_not include '?. '
        end
      end

      describe 'when given a phrase_maker' do
        let(:numbers) { Proc.new { rand(5) } }

        it 'returns paragraphy things made of sentency things made of results of calling it' do
          subject.lyrem(what: :paragraphs, how_many: 10, phrase_maker: numbers).each do |paragraph|
            expect(paragraph.length).to be > 10
            paragraph.split(' ').each do |number|
              expect(number.to_i).to be < 5
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

end
