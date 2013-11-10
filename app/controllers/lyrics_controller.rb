class LyricsController < ApplicationController

  def for_artist

    if request.query_parameters[:artist]
      redirect_query_parameters and return
    end

    unless params[:artist]
      raise ArgumentError
    end

    @artist = Artist.new(params[:artist]) or raise ArtistNotFoundError.new('artist not found')

    what = case params[:what]
             when 'phrase', 'phrases'
               :phrases
             when 'sentence', 'sentences'
               :sentences
             else
               :paragraphs
           end
    how_many = if params[:length].to_i > 0
                 params[:length].to_i
               else
                 5
               end

    lyrem = @artist.lyrem(what => how_many)

    render 'by_artist', locals: {artist: @artist, lyrem: lyrem}
  end

  private

  def redirect_query_parameters
    if request.query_parameters[:'text-length'] && request.query_parameters[:'text-length-unit']
      redirect_to artist_lyrem_path(artist: request.query_parameters[:artist].to_slug, length: request.query_parameters[:'text-length'], what: request.query_parameters[:'text-length-unit'])
    else
      redirect_to artist_lyrem_path(artist: request.query_parameters[:artist].to_slug)
    end
  end

  String.instance_eval do
    include CustomString
  end

  class ArtistNotFoundError < StandardError; end

end
