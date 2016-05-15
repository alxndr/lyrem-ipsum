defmodule LyricsWiki do

  alias LyricsWiki.Api

  @moduledoc """
  Interface with the Lyrics Wiki at lyrics.wikia.com.

  TODO:
  * monitor & space out requests
  """

  @regex_author ~r/^by [A-Z][a-z]/
  @regex_brackets ~r/^\[.+\]$/
  @regex_chorus ~r/^\[?(Bridge|Chorus):?\]?$/
  @regex_colon_then_uppercase_letter ~r/\w:[A-Z]/
  @regex_copyright ~r/(©|\(c\)|copyright)/i
  @regex_hash_then_uppercase_letter ~r/\w#[A-Z]/
  @regex_junk_around_match ~r/[\s]*(?<content>.+?)[\s;,.]*$/
  @regex_name_of_speaker_followed_by_colon ~r/^[A-Z][a-zA-Z'?-]+( #\d)?: /
  @regex_name_with_instrument_in_parens ~r/^([a-zA-Z'\-"]+ ){2,4}\([a-z, ]+\)$/
  @regex_number_of_times_in_parens ~r/^\(\d+ times\)$/
  @regex_repetition_indicator ~r/\s?[\(\[](x\d+|\d+x|\d+ times?)[\)\]]/
  @regex_surrounded_by_quotes ~r/^"[^"]+"$/

  use GenServer

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

  @spec random_lyric_from_song(String.t, String.t) :: String.t | nil
  def random_lyric_from_song(artist, song) do
    artist
    |> find_lyrics(song)
    |> random_or_nil
  end

  @doc """
  TODO: cache results
  """
  @spec find_lyrics(String.t, String.t) :: [String.t]
  def find_lyrics(artist, song) do
    %{artist: artist, song: song}
    |> song_info
    |> Api.fetch_lyrics
    |> sanitize_lyrics
  end





  @spec random_lyric_from_artist_info(%{}) :: String.t
  defp random_lyric_from_artist_info(artist_info) do
    song_title = random_song_from_artist_data(artist_info)
    random_lyric_from_song(artist_info["artist"], song_title)
  end

  @docp """
  n.b. this skips songs which don't have lyrics
  """
  @spec random_song_from_artist_data(%{}) :: String.t
  defp random_song_from_artist_data(artist_info) do
    artist_name = artist_info["artist"]
    artist_info
    |> extract_songs
    |> Enum.shuffle
    |> Stream.filter(&song_title_looks_good?/1)
    |> Stream.filter(&song_has_lyrics?(artist_name, &1))
    |> Enum.take(1)
    |> hd
  end

  @spec song_info(%{}) :: %{}
  defp song_info(%{artist: artist, song: song}) do
    Api.fetch_song_info(artist, song)
  end

  @spec song_title_looks_good?(String.t) :: boolean
  defp song_title_looks_good?(song_title) do
    !Regex.match?(@regex_colon_then_uppercase_letter, song_title)
    && !Regex.match?(@regex_hash_then_uppercase_letter, song_title)
    && !Regex.match?(@regex_surrounded_by_quotes, song_title)
  end

  @spec song_has_lyrics?(String.t, String.t) :: boolean
  defp song_has_lyrics?(artist_name, song_title) do
    lyrics = find_lyrics(artist_name, song_title)
    Enum.count(lyrics) > 0
  end

  @spec sanitize_lyrics([String.t]) :: [String.t]
  defp sanitize_lyrics(lyrics) do
    lyrics
    |> Enum.reduce([], &sanitize_lyrics/2)
    |> Enum.reverse
  end

  @docp """
  n.b. this reverses the order of the reduce input
  """
  @spec sanitize_lyrics(String.t, [String.t]) :: [String.t]
  defp sanitize_lyrics("", sanitized_lyrics), do: sanitized_lyrics
  defp sanitize_lyrics(lyric, sanitized_lyrics) do
    lyric = String.strip(lyric)
    cond do
      Regex.match?(@regex_number_of_times_in_parens, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_author, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_chorus, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_copyright, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_name_with_instrument_in_parens, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_brackets, lyric) ->
        sanitized_lyrics
      true ->
        [strip_junk(lyric) | sanitized_lyrics]
    end
  end

  @spec strip_junk(String.t) :: String.t
  defp strip_junk(raw_lyric) do
    Regex.replace(@regex_junk_around_match, raw_lyric, "\\1")
    |> String.replace(@regex_name_of_speaker_followed_by_colon, "")
    |> String.replace(@regex_repetition_indicator, "")
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

  @spec random_or_nil([any]) :: any | nil
  defp random_or_nil([]), do: nil
  defp random_or_nil(list) do
    Enum.random(list)
  end

end
