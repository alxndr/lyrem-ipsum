require 'spec_helper'

describe CustomArray do

  describe '#join_avoiding_dupe_punctuation' do

    class TestCustomArray < Array
      include CustomArray
    end

    let(:test_array) { TestCustomArray.new(%w(Foo... Bar baz! quux)) }

    subject { test_array.join_avoiding_dupe_punctuation(', ') }

    it 'returns a string' do
      subject.should be_a String
    end

    describe 'when the glue would not follow an unwanted character' do
      it 'does insert glue' do
        subject[/[a-z], /i].should_not be nil
      end
    end

    describe 'when the glue would follow an unwanted character' do
      it 'does not insert glue' do
        subject['.,'].should be nil
        subject['!,'].should be nil
      end
    end

  end

end
