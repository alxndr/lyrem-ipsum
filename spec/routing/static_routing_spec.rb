require 'spec_helper'

describe StaticController, type: :controller do
  describe 'routing' do

    describe '/' do
      it 'should route to StaticController#index' do
        expect(get: '/').to route_to(controller: 'static', action: 'index')
      end
    end

    describe '/health' do
      it 'should route to StaticController#health' do
        expect(get: '/health').to route_to(controller: 'static', action: 'health')
      end
    end

  end
end
