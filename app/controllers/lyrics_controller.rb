class LyricsController < ApplicationController

  def for_artist

    if request.query_parameters[:artist]
      redirect_query_parameters and return
    end

    unless params[:artist]
      raise ArgumentError
    end

    artist_name = MusicianNameFinder.look_up(params[:artist])

    @artist = find_or_create_artist(artist_name)

    what = interpret_what params[:what]
    how_many = interpret_how_many params[:length]

    render 'by_artist', locals: { artist: @artist, lyrem: @artist.lyrem(what: what, how_many: how_many) }
  end

  private

  def find_or_create_artist(name)
    artist = Artist.find_by_slug(name.to_slug)
    unless artist
      artist = Artist.new
      artist.get_data(name)
      artist.save
    end
    artist
  end

  def interpret_what(input)
    case input
    when 'phrase', 'phrases'
      :phrases
    when 'sentence', 'sentences'
      :sentences
    else
      :paragraphs
    end
  end

  def interpret_how_many(input)
    if params[:length].to_i > 0
      params[:length].to_i
    else
      5
    end
  end

  def redirect_query_parameters
    @artist = find_or_create_artist(params[:artist]) or raise ArtistNotFoundError.new('artist not found')

    path_options = { artist: @artist.slug }
    path_options.merge!(length: params[:'text-length'], what: params[:'text-length-unit']) if params[:'text-length'] && params[:'text-length-unit']

    redirect_to artist_lyrem_path(path_options)
  end

  String.instance_eval do
    include CustomString
  end

  class ArtistNotFoundError < StandardError; end

end
