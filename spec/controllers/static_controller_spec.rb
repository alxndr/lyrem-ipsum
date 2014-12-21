require 'spec_helper'

describe StaticController, type: :controller do

  describe '#index' do
    it 'should be successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe '#health' do
    it 'should be successful' do
      get :health
      expect(response).to be_successful
    end
  end
end
