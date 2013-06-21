class LyricsController < ApplicationController

  class ArtistNotFoundError < StandardError; end

  def for_artist

    if request.query_parameters[:artist]
      redirect_to "/text-from-lyrics-by/#{request.query_parameters[:artist].to_slug}" and return
    end

    unless params[:artist]
      raise ArgumentError
    end

    @artist = Artist.new(name: params[:artist].gsub('-',' ')) # TODO better sanitization?

    if @artist && @artist.present?
      @artist.fetch_data
      render 'by_artist'
    else
      raise ArtistNotFoundError.new('artist not found')
    end
  end

  String.instance_eval do
    include CustomString
  end

end
