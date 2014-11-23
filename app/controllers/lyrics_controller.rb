class LyricsController < ApplicationController

  def for_artist
    if request.query_parameters[:artist]
      redirect_query_parameters
      return
    end

    raise ArgumentError unless params[:artist]

    artist_name = determine_artist_name(params[:artist])
    return unless artist_name

    @artist = find_or_create_artist(artist_name)

    what = interpret_what(params[:what])
    how_many = interpret_how_many(params[:length])

    render 'by_artist', locals: { artist: @artist, lyrem: @artist.lyrem(what: what, how_many: how_many) }
  end

  private

  def find_or_create_artist(name)
    Artist.find_or_create name
  end

  def interpret_what(input)
    case input
    when 'phrase', 'phrases'
      :phrases
    when 'paragraph', 'paragraphs'
      :paragraphs
    else
      :sentences
    end
  end

  def interpret_how_many(input)
    if params[:length].to_i > 0
      params[:length].to_i
    else
      10
    end
  end

  def determine_artist_name(input)
    MusicianNameFinder.look_up(params[:artist])
  rescue MusicianNameFinder::UnknownArtistError
    render('static/unknown_artist', status: :not_found, locals: { name: params[:artist] })
    nil
  end

  def redirect_query_parameters
    artist_name = determine_artist_name(params[:artist])
    return unless artist_name

    @artist = find_or_create_artist(artist_name) or raise ArtistNotFoundError.new('artist not found')

    path_options = { artist: @artist.slug }
    path_options.merge!(length: params[:'text-length'], what: params[:'text-length-unit']) if params[:'text-length'] && params[:'text-length-unit']

    redirect_to artist_lyrem_path(path_options)
  end

  String.instance_eval do
    include CustomString
  end

  class ArtistNotFoundError < StandardError; end

end
