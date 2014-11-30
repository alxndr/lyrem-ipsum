require 'spec_helper'

describe CustomString do

  class TestCustomString < String
    include CustomString
  end

   describe '#capitalize_first_letter' do
    it 'capitalizes the first letter' do
      TestCustomString.new('þrettán').capitalize_first_letter.should == 'Þrettán'
      TestCustomString.new('!!!1 bar').capitalize_first_letter.should == '!!!1 Bar'
      TestCustomString.new('qux QUUX').capitalize_first_letter.should == 'Qux QUUX'
      TestCustomString.new('QUX Quux').capitalize_first_letter.should == 'QUX Quux'
    end

    it 'does not double-capitalize' do
      TestCustomString.new('Baz').capitalize_first_letter.should == 'Baz'
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
      subject[0].should_not == ' '
    end
    it 'downcases' do
      subject['I'].should == nil
    end
    it 'strips apostrophes' do
      subject["'"].should == nil
    end
    it 'converts & -> and' do
      subject['&'].should == nil
      subject['and'].should_not == nil
    end
    it 'only comprises [a-z-]' do
      subject.should match /^[a-z-]+$/
    end
    it 'does not have any double-hyphens' do
      subject['--'].should == nil
    end
    it 'starts and ends with a letter' do
      subject.first.should match /[a-z]/
      subject.last.should match /[a-z]/
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
