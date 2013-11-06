LyremIpsum::Application.routes.draw do
  root 'static#index'

  get '/text-from-lyrics-by(/:artist(/:length)(/:what))' => 'lyrics#for_artist', :as => 'artist_lyrem'
end

