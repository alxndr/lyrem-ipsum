require 'spec_helper'

describe StaticController do
  describe '#index' do
    it 'should be successful' do
      get :index
      response.should be_successful
    end
  end
end

