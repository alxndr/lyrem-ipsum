defmodule LyremIpsum.ArtistController do
  use LyremIpsum.Web, :controller

  def by_artist(conn, params) do
    render conn, "by_artist.html", artist: params["artist"]
  end

end
