require 'spec_helper'

describe Artist do

  describe '#random_lyric' do

    before do
      Artist.stub(find_artist_name: 'Frank Zappa')
      Artist.any_instance.stub(fetch_data_for_artist: {})
    end

    describe 'when lyrics available' do
      it 'returns a lyric' do
        lyrics = %w(jamming in joe's garage)
        Artist.any_instance.stub(:fetch_new_song_lyrics).and_return(lyrics)
        lyrics.should include Artist.new(name: 'frank zappa').random_lyric
      end
    end

    describe 'when no new lyrics available' do
      before do
        Artist.any_instance.stub(fetch_new_song_lyrics: nil)
      end
      it 'samples known lyrics' do
        fz = Artist.new name: 'f zappa'
        fz.send(:instance_variable_set, :@lyrics, ['was it round and did it have a motor'])
        fz.random_lyric.should == 'was it round and did it have a motor'
      end
    end

  end

  describe '#lyrem' do

    before do
      Artist.stub(find_artist_name: 'Frank Zappa')
      Artist.any_instance.stub(fetch_data_for_artist: {})
    end

    let(:fz) { Artist.new(name: 'frank zappa') }
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
      fz.stub(:fetch_new_song_lyrics).and_return(phrases)
    end

    describe ':phrases' do
      it 'returns an array of n strings' do
        phrases = fz.lyrem(phrases: 3)
        phrases.length.should == 3
        phrases.first.class.should == String # fetch_new_song_lyrics.class
        phrases.each do |phrase|
          phrases.should include phrase
        end
      end

      describe 'when given a phrase_picker' do
        let(:numbers) { Proc.new { rand(5) } }

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
          sentence.split(' ').length.should >= 2
          %w(,, ., !, ?, ,. !. ?.).each do |punct_combo|
            sentence.should_not include punct_combo
          end
        end
      end

      it 'capitalizes the first letter' do
        /[a-z]/i.match(fz.lyrem(sentences: 1).first)[0].should match /[A-Z]/
      end

      describe 'when given a phrase_picker' do
        let(:new_phrases) { phrases.map { |p| p.upcase } }
        let(:phrase_picker) { Proc.new { new_phrases.sample } }

        it 'returns sentency things made of results of calling it' do
          fz.lyrem(sentences: 10, phrase_picker: phrase_picker).each do |sentence|
            new_phrases.any? { |new_phrase| sentence.include? new_phrase }.should be_true
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
        let(:numbers) { Proc.new { rand(5) } }

        it 'returns paragraphy things made of sentency things made of results of calling it' do
          fz.lyrem(paragraphs: 10, phrase_picker: numbers).each do |paragraph|
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
        expect { fz.lyrem }.to raise_error ArgumentError
        expect { fz.lyrem foo: :bar }.to raise_error ArgumentError
      end
    end
  end

end
