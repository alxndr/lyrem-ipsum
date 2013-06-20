class LyricsController < ApplicationController

  class ArtistNotFoundError < StandardError; end

  def for_artist
    if request.query_parameters[:artist]
      redirect_to "/text-from-lyrics-by/#{request.query_parameters[:artist]}" and return
    end

    unless params[:artist]
      raise ArgumentError
    end

    @artist = Artist.new(params[:artist].gsub('-',' '))

    if @artist && @artist.present?
      render 'by_artist'
    else
      raise ArtistNotFoundError.new('artist not found')
    end
  end

end

