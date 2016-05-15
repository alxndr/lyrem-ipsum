defmodule LyricsWiki do

  @moduledoc """
  Interface with the Lyrics Wiki at lyrics.wikia.com.

  TODO:
  * monitor & space out requests
  """

  use GenServer

  alias LyricsWiki.{
    Api,
    Sanitizer
  }

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def random_lyric(registry, artist) do
    GenServer.call(registry, {:random_lyric, artist})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:random_lyric, artist}, _from, state) do
    if state[artist] do
      lyric = random_lyric_from_artist_info(state[artist])
      {:reply, lyric, state}
    else
      artist_info = Api.fetch_artist_info(artist)
      lyric = random_lyric_from_artist_info(artist_info)
      {:reply, lyric, Map.put(state, artist, artist_info)}
    end
  end



  @spec random_lyric_by_artist(String.t) :: String.t | nil
  def random_lyric_by_artist(artist) do
    artist
    |> Api.fetch_artist_info
    |> random_lyric_from_artist_info
  end

  @doc """
  TODO: cache results
  """
  @spec find_lyrics(String.t, String.t) :: [String.t]
  def find_lyrics(artist, song) do
    %{artist: artist, song: song}
    |> song_info
    |> Api.fetch_lyrics
    |> Sanitizer.sanitize_lyrics
  end





  @spec random_lyric_from_artist_info(%{}) :: String.t
  defp random_lyric_from_artist_info(artist_info) do
    artist_info
    |> random_song_lyrics_from_artist_data
  end

  @docp """
  n.b. this skips songs which don't have lyrics
  """
  @spec random_song_lyrics_from_artist_data(%{}) :: String.t
  defp random_song_lyrics_from_artist_data(artist_info) do
    artist_name = artist_info["artist"]
    artist_info
    |> extract_songs
    |> Enum.shuffle
    |> Stream.filter(&Sanitizer.song_title_looks_good?/1)
    |> Stream.map(&find_lyrics(artist_name, &1))
    |> Stream.filter(&has_lyrics?/1)
    |> Enum.take(1)
    |> hd
    |> Enum.random
  end

  defp has_lyrics?([]), do: false
  defp has_lyrics?(list) when length(list) > 0 -> true

  @spec song_info(%{}) :: %{}
  defp song_info(%{artist: artist, song: song}) do
    Api.fetch_song_info(artist, song)
  end

  @spec extract_songs(%{}) :: [String.t]
  defp extract_songs(artist_info) do
    artist_info["albums"]
    |> Enum.filter(&album_title_looks_good?/1)
    |> Enum.flat_map(&(&1["songs"]))
    |> Enum.uniq
  end

  @spec album_title_looks_good?(%{}) :: boolean
  defp album_title_looks_good?(album_data) do
    album_data["year"] != nil
  end

end
