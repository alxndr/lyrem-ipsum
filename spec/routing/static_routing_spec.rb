require 'spec_helper'

pending StaticController do
  describe 'routing' do

    describe 'index' do
      it 'should route to StaticController#index' do
        expect(get: '/').to route_to(controller: 'static', action: 'index')
      end
    end

  end
end
