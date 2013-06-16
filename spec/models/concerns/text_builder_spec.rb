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
  end

end
