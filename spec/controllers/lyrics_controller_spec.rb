require 'spec_helper'

describe LyricsController, type: :controller do

  describe '#by_artist' do

    before do
      allow(Artist).to receive(:new) do
        mock_model Artist, get_data: true, save: true, load_data: true, lyrem: true
      end
    end

    describe 'missing artist' do
      it 'raises' do
        expect { get :for_artist }.to raise_error ArgumentError
        expect { get :for_artist, foo: 'bar' }.to raise_error ArgumentError
      end
    end

    describe 'when passed artist' do

      describe 'via url' do

        describe 'with correct name' do
          describe 'when "local" artist' do
            before do
              allow(Artist).to receive(:find_by_slug).and_return Artist.new

              get :for_artist, artist: 'frank-zappa'
            end

            it 'assigns @artist' do # behaves_like
              expect(assigns(:artist)).to be_an Artist
            end

            it 'renders' do # behaves_like
              expect(response).to render_template 'by_artist'
            end
          end

          describe 'when not "local" artist' do
            before do
              allow(Artist).to receive(:find_by_slug).and_return nil
              a = Artist.new
              allow(a).to receive(:save!)
              allow(Artist).to receive(:new).and_return a

              get :for_artist, artist: 'frank-zappa'
            end

            it 'assigns @artist' do # behaves_like
              expect(assigns(:artist)).to be_an Artist
            end

            it 'renders' do # behaves_like
              expect(response).to render_template 'by_artist'
            end
          end
        end

        describe 'not found artist' do
          xit 'renders unknown artist page' do
            get :for_artist, artist: 'not a real person'

            expect(response).to render_template 'static/unknown_artist'
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
