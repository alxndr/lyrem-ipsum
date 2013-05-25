class LyricsController < ApplicationController

  def for_artist
    @artist = Artist.new(params[:artist])

    if @artist && @artist.present?
      render 'by_artist'
    else
      raise StandardError.new('Missing artist?')
    end
  end

end

