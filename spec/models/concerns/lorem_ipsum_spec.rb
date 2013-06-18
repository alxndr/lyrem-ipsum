require 'spec_helper'

describe LoremIpsum do

  describe '.word' do
    it 'samples the CORPUS const' do
      test_corpus = %w(amazing beautiful creatures dancing)
      stub_const 'LoremIpsum::CORPUS', test_corpus

      test_corpus.should include LoremIpsum.word
    end
  end

  describe '.phrase' do
    it 'returns a string of 2 >= n >= 6 corpus words' do
      test_corpus = %w(amazing beautiful creatures dancing)
      test_conjunctions = %w(and)
      stub_const 'LoremIpsum::CORPUS', test_corpus
      stub_const 'LoremIpsum::CONJUNCTIONS', test_conjunctions

      words = LoremIpsum.phrase.split(/\s/)
      words.length.should >= 2
      words.length.should <= 6 + 1 # +1 for potential connector
      words.each do |word|
        (test_corpus + test_conjunctions).should(include(word))
      end
    end

    it 'sometimes includes a connector' do
      pending 'how to test randomness? or replace that decisionmaking?'
    end
  end

end
