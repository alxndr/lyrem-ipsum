class LyricsController < ApplicationController

  def for_artist
    @artist = params[:artist]
    if @artist && @artist.present?
      render 'by_artist'
    else
      raise StandardError.new('Missing artist?')
    end
  end

end

