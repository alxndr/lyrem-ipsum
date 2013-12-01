require 'spec_helper'

describe LyricsController do

  describe '#by_artist' do

    before do
      Artist.stub(:new) { mock_model(Artist, save: true, lyrem: true) }
    end

    describe 'missing artist' do
      it 'raises' do
        expect{ get :for_artist }.to raise_error ArgumentError
        expect{ get :for_artist, foo: 'bar' }.to raise_error ArgumentError
      end
    end

    describe 'when passed artist' do

      describe 'via url' do

        describe 'with correct name' do
          before do
            MusicianNameFinder.stub(look_up: 'FZ')
          end

          describe 'when "local" artist' do
            before do
              Artist.stub(find_by_slug: Artist.new)
            end

            it 'assigns @artist' do # behaves_like
              get :for_artist, artist: 'frank-zappa'

              assigns(:artist).should be_true
            end

            it 'renders' do # behaves_like
              get :for_artist, artist: 'frank-zappa'

              response.should render_template 'by_artist'
            end
          end

          describe 'when not "local" artist' do
            before do
              Artist.stub(find_by_slug: nil)
            end

            before do
              Artist.stub(:new) { mock_model(Artist, get_data: true, save: true, lyrem: true) }
            end

            it 'assigns @artist' do # behaves_like
              get :for_artist, artist: 'frank-zappa'

              assigns(:artist).should be_true
            end

            it 'renders' do # behaves_like
              get :for_artist, artist: 'frank-zappa'

              response.should render_template 'by_artist'
            end
          end
        end

        describe 'not found artist' do
          before do
            Artist.stub(:new).and_return(nil)
          end

          it 'errors' do
            expect{ get :for_artist, artist: 'not a real person' }.to raise_error
          end
        end

      end

      describe 'via query string' do
        it 'redirects' do
          pending 'how to set request.query_parameters and not request.parameters?'
          get :for_artist, artist: 'frank zappa'
          response.should_not redirect_to '/text-from-lyrics-by/frank zappa'
          response.should redirect_to '/text-from-lyrics-by/frank-zappa'
        end
      end

    end
  end

end

class ArtistNotFoundError < StandardError; end
