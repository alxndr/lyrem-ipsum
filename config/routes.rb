LyremIpsum::Application.routes.draw do
  root 'static#index'

  get '/text-from-lyrics-by(/:artist)' => 'lyrics#for_artist'
end

