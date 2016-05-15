defmodule LyremIpsum do

  @spec find_lyrics(String.t, String.t) :: [String.t]
  def find_lyrics(artist, song) do
    LyricsWiki.find_lyrics(artist, song)
  end

  @spec random_lyric_by(String.t) :: String.t
  def random_lyric_by(artist) do
    artist
    |> LyricsWiki.random_lyric_by_artist
  end

end
