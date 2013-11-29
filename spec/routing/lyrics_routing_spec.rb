require 'spec_helper'

describe LyricsController do
  describe 'routing' do


    describe '/text-from-lyrics-by/queen' do
      it 'should route to LyricsController#for_artist' do
        expect(get: '/text-from-lyrics-by/queen').to route_to(controller: 'lyrics', action: 'for_artist', artist: 'queen')
      end
    end

    describe '/text-from-lyrics-by/queen/3/sentences' do
      it 'should route to LyricsController#for_artist' do
        expect(get: '/text-from-lyrics-by/queen/3/sentences').to route_to(controller: 'lyrics', action: 'for_artist', artist: 'queen', length: '3', what: 'sentences')
      end
    end

  end
end
