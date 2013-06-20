require 'spec_helper'

describe TextBuilder do

  describe '.construct' do

    it 'raises unless it has something to call' do
      expect {
        TextBuilder.construct
      }.to raise_error ArgumentError
      expect {
        TextBuilder.construct 0, 1, 2
      }.to raise_error ArgumentError
    end

    it 'raises unless min and max length make sense' do
      expect {
        TextBuilder.construct lambda{}, 2, 1
      }.to raise_error ArgumentError
      expect {
        TextBuilder.construct lambda{}, -1, 1
      }.to raise_error ArgumentError

    end

    it 'calls the first parameter at least {min} and at most {max} times, and returns results' do
      i = 0
      proc = Proc.new { i += 1 }
      proc.should_receive(:call).at_least(10).at_most(20).times.and_call_original
      TextBuilder.construct(proc, 1, 13)
    end

  end

end
