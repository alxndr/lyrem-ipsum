require 'spec_helper'

describe LoremIpsum do

  describe '.word' do
    it 'samples the CORPUS const' do
      test_corpus = %w(amazing beautiful creatures dancing)
      stub_const 'LoremIpsum::CORPUS', test_corpus
      test_corpus.should include subject.class.word
    end
  end

  describe '.phrase' do
    it 'returns a string of 2 >= n >= 6 corpus words' do
      subject.class.stub(:word).and_return 'lorem', 'ipsum'
      p = subject.class.phrase
      p.count('lorem').should >= 2
      p.count('lorem').should <= 6 + 1 # +1 for connectors
    end

    it 'sometimes includes a connector' do
      pending 'how to test randomness? or replace that decisionmaking?'
    end
  end

end
