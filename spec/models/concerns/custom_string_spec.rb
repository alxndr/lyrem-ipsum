require 'spec_helper'

describe CustomString do

  class TestCustomString < String
    include CustomString
  end

  describe '#to_slug' do
    let(:test_string) { TestCustomString.new " It's  a  String  & Whatnot! " }

    subject { test_string.to_slug }

    it 'strips' do
      expect(subject[0]).to_not eq ' '
    end
    it 'downcases' do
      expect(subject['I']).to eq nil
    end
    it 'strips apostrophes' do
      expect(subject["'"]).to eq nil
    end
    it 'converts & -> and' do
      expect(subject['&']).to eq nil
      expect(subject['and']).to_not eq nil
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
        expect(TestCustomString.new().valid_lyric?).to eq false
        expect(TestCustomString.new('').valid_lyric?).to eq false
      end
    end

    describe 'when not containing any letters' do
      it 'returns nil' do
        expect(TestCustomString.new('!@#$%^&*() ... 1234567890').valid_lyric?).to eq nil
      end
    end

    describe 'when containing a suspicious word' do
      it 'retruns false' do
        expect(TestCustomString.new('Not Found').valid_lyric?).to eq false
        expect(TestCustomString.new('instrumental').valid_lyric?).to eq false
        expect(TestCustomString.new('transcribed').valid_lyric?).to eq false
        expect(TestCustomString.new('COPYRIGHT').valid_lyric?).to eq false
        expect(TestCustomString.new('chorus').valid_lyric?).to eq false
      end
    end

    describe 'when really long' do
      it 'returns false' do
        expect(TestCustomString.new('hey ' * 100).valid_lyric?).to eq false
      end
    end

    describe 'otherwise' do
      it 'returns true' do
        expect(TestCustomString.new(' ...this is probably a valid lyric...').valid_lyric?).to eq true
      end
    end

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

end
