require 'spec_helper'

describe CustomArray do

  describe '#join_after_regex' do

    class TestCustomArray < Array
      include CustomArray
    end

    let(:test_array) { TestCustomArray.new(%w(foo bar baz qux)) }

    it 'returns a string' do
      test_array.join_after_regex(glue: ', ', regex: /a/).should be_a String
    end

    describe 'matching regex' do
      subject { test_array.join_after_regex(glue: ', ', regex: /o/) }
      it 'inserts glue' do
        subject.index('o,').should_not be nil
      end
    end

    describe 'not matching regex' do
      subject { test_array.join_after_regex(glue: ', ', regex: /o/) }
      it 'does not insert glue' do
        subject.index('r,').should be nil
        subject.index('z,').should be nil
      end
    end

    describe 'missing some pieces' do
      it 'raises' do
        expect{ test_array.join_after_regex(glue: 'foo') }.to raise_error ArgumentError
        expect{ test_array.join_after_regex(regex: /foo/) }.to raise_error ArgumentError
      end
    end

  end

end
