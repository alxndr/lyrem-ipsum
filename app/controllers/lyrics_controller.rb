class LyricsController < ApplicationController

  def for_artist

    if request.query_parameters[:artist]
      redirect_query_parameters and return
    end

    unless params[:artist]
      raise ArgumentError
    end

    artist_name = LyricsController.find_name(params[:artist])

    @artist = Artist.find_by_slug(artist_name.to_slug) || Artist.new(name: artist_name)
    @artist.save

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

    render 'by_artist', locals: {artist: @artist, lyrem: @artist.lyrem(what => how_many)}
  end

  private

  def redirect_query_parameters
    @artist = Artist.new(name: params[:artist]) or raise ArtistNotFoundError.new('artist not found')

    if request.query_parameters[:'text-length'] && request.query_parameters[:'text-length-unit']
      redirect_to artist_lyrem_path(artist: @artist.slug, length: request.query_parameters[:'text-length'], what: request.query_parameters[:'text-length-unit'])
    else
      redirect_to artist_lyrem_path(artist: @artist.slug)
    end
  end

  def self.find_name(input)
    result = Google::Search::Web.new(query: "#{input} musician site:en.wikipedia.org").first
    unless result && result.title
      raise 'artist name not found'
    end
    result.title.chomp(' - Wikipedia, the free encyclopedia')
  end

  String.instance_eval do
    include CustomString
  end

  class ArtistNotFoundError < StandardError; end

end
