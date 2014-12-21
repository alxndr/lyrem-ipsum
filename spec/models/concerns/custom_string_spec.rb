require 'spec_helper'

describe CustomString do

  class TestCustomString < String
    include CustomString
  end

  describe '#capitalize_first_letter' do
    it 'capitalizes the first letter' do
      expect(TestCustomString.new('þrettán').capitalize_first_letter).to eq 'Þrettán'
      expect(TestCustomString.new('!!!1 bar').capitalize_first_letter).to eq '!!!1 Bar'
      expect(TestCustomString.new('qux QUUX').capitalize_first_letter).to eq 'Qux QUUX'
      expect(TestCustomString.new('QUX Quux').capitalize_first_letter).to eq 'QUX Quux'
    end

    it 'does not double-capitalize' do
      expect(TestCustomString.new('Baz').capitalize_first_letter).to eq 'Baz'
    end
  end

  describe '#is_suspected_cover?' do
    describe 'when Name:Song' do
      subject { TestCustomString.new('Foo:Bar') }
      it 'should be true' do
        expect(subject.looks_like_cover_song?).to be_truthy
      end
    end
    describe 'when not Name:Song' do
      subject { TestCustomString.new("Foo's Bar") }
      it 'should be false' do
        expect(subject.looks_like_cover_song?).to be_falsey
      end
    end
  end

  describe '#sanitize_lyric' do
    it 'strips whitespace' do
      expect(TestCustomString.new(' foo ').sanitize_lyric).to eq 'foo'
    end
    it 'removes things in brackets' do
      expect(TestCustomString.new('foo [bar]').sanitize_lyric).to eq 'foo'
    end
    it 'removes html tags' do
      expect(TestCustomString.new('<foo> bar').sanitize_lyric).to eq 'bar'
    end
    it 'removes html tag contents' do
      expect(TestCustomString.new('<foo>bar</foo> baz').sanitize_lyric).to eq 'baz'
    end
  end

  describe '#to_slug' do
    let(:test_string) { TestCustomString.new " It's  a  String  & Whatnot! " }

    subject { test_string.to_slug }

    it 'strips' do
      expect(subject[0]).not_to eq ' '
    end
    it 'downcases' do
      expect(subject['I']).to eq nil
    end
    it 'strips apostrophes' do
      expect(subject["'"]).to eq nil
    end
    it 'converts & -> and' do
      expect(subject['&']).to eq nil
      expect(subject['and']).not_to eq nil
    end
    it 'only comprises [a-z-]' do
      expect(subject).to match /^[a-z-]+$/
    end
    it 'does not have any double-hyphens' do
      expect(subject['--']).to eq nil
    end
    it 'starts and ends with a letter' do
      expect(subject.first).to match /[a-z]/
      expect(subject.last).to match /[a-z]/
    end
  end

  describe '#valid_lyric?' do

    describe 'when nil or empty' do
      it 'returns false' do
        expect(TestCustomString.new()).not_to be_valid_lyric
        expect(TestCustomString.new('')).not_to be_valid_lyric
      end
    end

    describe 'when not containing any letters' do
      it 'returns false' do
        expect(TestCustomString.new('!@#$%^&*() ... 1234567890')).not_to be_valid_lyric
      end
    end

    describe 'when containing a suspicious word' do
      it 'retruns false' do
        expect(TestCustomString.new('Not Found')).not_to be_valid_lyric
        expect(TestCustomString.new('instrumental')).not_to be_valid_lyric
        expect(TestCustomString.new('transcribed')).not_to be_valid_lyric
        expect(TestCustomString.new('COPYRIGHT')).not_to be_valid_lyric
        expect(TestCustomString.new('chorus')).not_to be_valid_lyric
      end
    end

    describe 'when really long' do
      it 'returns false' do
        expect(TestCustomString.new('hey ' * 100)).not_to be_valid_lyric
      end
    end

    describe 'otherwise' do
      it 'returns true' do
        expect(TestCustomString.new(' ...this is probably a valid lyric...')).to be_valid_lyric
      end
    end

  end

end
