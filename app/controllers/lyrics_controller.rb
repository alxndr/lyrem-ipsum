class LyricsController < ApplicationController

  class ArtistNotFoundError < StandardError; end

  def for_artist

    if request.query_parameters[:artist]
      if request.query_parameters[:'text-length'] && request.query_parameters[:'text-length-unit']
        redirect_to "/text-from-lyrics-by/#{request.query_parameters[:artist].to_slug}/#{request.query_parameters[:'text-length']}/#{request.query_parameters[:'text-length-unit']}" and return
      else
        redirect_to "/text-from-lyrics-by/#{request.query_parameters[:artist].to_slug}" and return
      end
    end

    unless params[:artist]
      raise ArgumentError
    end

    @artist = Artist.new(params[:artist].gsub('-',' '))
    @how_many = params[:length] || 5
    @what = params[:what] || 'paragraphs'

    if @artist && @artist.present?
      render 'by_artist'
    else
      raise ArtistNotFoundError.new('artist not found')
    end
  end

  String.instance_eval do
    include CustomString
  end

end
