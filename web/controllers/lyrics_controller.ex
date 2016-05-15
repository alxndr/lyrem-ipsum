defmodule LyremIpsum.LyricsController do
  use LyremIpsum.Web, :controller

  def random_lyric(conn, params) do
    render conn, "random_lyric.html", artist: params["artist"]
  end
end
