require 'spec_helper'

describe CustomString do

  class TestCustomString < String
    include CustomString
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
        TestCustomString.new().valid_lyric?.should be_false
        TestCustomString.new('').valid_lyric?.should be_false
      end
    end

    describe 'when not containing any letters' do
      it 'returns false' do
        TestCustomString.new('!@#$%^&*() ... 1234567890').valid_lyric?.should be_false
      end
    end

    describe 'when containing a suspicious word' do
      it 'retruns false' do
        TestCustomString.new('Not Found').valid_lyric?.should be_false
        TestCustomString.new('instrumental').valid_lyric?.should be_false
        TestCustomString.new('transcribed').valid_lyric?.should be_false
        TestCustomString.new('COPYRIGHT').valid_lyric?.should be_false
        TestCustomString.new('chorus').valid_lyric?.should be_false
      end
    end

    describe 'otherwise' do
      it 'returns true' do
        TestCustomString.new(' ...this is probably a valid lyric...').valid_lyric?.should be_true
      end
    end

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

end
