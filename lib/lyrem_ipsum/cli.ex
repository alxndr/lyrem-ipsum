defmodule LyremIpsum.Cli do

  @defmodule """
  TODO:
  * canonicalize artist names
  """

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    [
      worker(LyricsWiki, [LyricsWiki]),
    ]
    |> supervise(strategy: :one_for_one)
  end

  @spec lyrics_of_song(String.t, String.t) :: [String.t]
  def lyrics_of_song(artist, song) do
    LyricsWiki.find_lyrics(artist, song)
  end

  @spec random_lyric_by(String.t) :: String.t | nil
  def random_lyric_by(artist) do
    LyricsWiki.random_lyric_by_artist(artist)
  end

end
