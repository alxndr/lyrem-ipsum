require 'spec_helper'

describe StaticController do
  describe 'routing' do

    describe 'index' do
      it 'should route to StaticController#index' do
        expect(get: '/').to route_to(controller: 'static', action: 'index')
      end
    end

    describe 'health' do
      it 'should route to health check' do
        expect(get: '/health').to route_to(controller: 'static', action: 'health')
      end
    end

  end
end
