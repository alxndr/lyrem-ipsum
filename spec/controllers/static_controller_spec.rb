require 'spec_helper'

pending StaticController do
  describe '#index' do
    it 'should exist' do
      expect(StaticController.new.index).not_to raise_error
    end
  end
end
