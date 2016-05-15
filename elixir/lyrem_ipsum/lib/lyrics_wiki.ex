defmodule LyricsWiki do

  @moduledoc """
  Interface with the Lyrics Wiki at lyrics.wikia.com.

  TODO:
  * monitor & space out requests
  """

  @api_url "http://lyrics.wikia.com/api.php"

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
      lyric = random_song_from_artist_data(state[artist])
      {:reply, lyric, state}
    else
      artist_info = fetch_artist_info(artist)
      song_title = random_song_from_artist_data(artist_info)
      lyric = get_random_lyric_from_song(artist, song_title)
      {:reply, lyric, Map.put(state, artist, artist_info)}
    end
  end

  @spec random_lyric_by_artist(String.t) :: String.t | nil
  def random_lyric_by_artist(artist) do
    song = random_song(artist)
    get_random_lyric_from_song(artist, song)
  end

  @spec get_random_lyric_from_song(String.t, String.t) :: String.t | nil
  def get_random_lyric_from_song(artist, song) do
    IO.puts "\n\tfinding a random line from \"#{song}\"..."
    try do
      find_lyrics(artist, song)
      |> (fn (lyrics) -> IO.puts "\t#{Enum.count(lyrics)} lines...\n"; lyrics end).()
      |> Enum.random # find_lyrics/2 can return [] which causes this to throw...
    rescue
      _ in Enum.EmptyError -> nil
      # TODO LyremIpsum should launch something to do this, and retry if it throws Enum.EmptyError.
    end
  end

  @spec find_lyrics(String.t, String.t) :: [String.t]
  def find_lyrics(artist, song) do
    %{artist: artist, song: song}
    |> song_info
    |> fetch_lyrics
  end

  @spec random_song(String.t) :: %{}
  def random_song(artist) do
    artist
    |> fetch_artist_info
    |> random_song_from_artist_data
  end

  def random_song_from_artist_data(artist_info) do
    artist_info
    |> extract_songs
    |> Enum.filter(&song_title_looks_good?/1)
    |> Enum.random
  end

  @spec fetch_artist_info(String.t) :: %{}
  def fetch_artist_info(name) do
    HTTPotion.get(@api_url, query: query_params(func: "getArtist", artist: name), timeout: 10_000)
    |> decode_json
    # TODO store this in memory
  end




  @spec song_info(%{}) :: %{}
  def song_info(%{artist: artist, song: song}) do
    fetch_song_info(artist, song)
    |> decode_json
  end

  @spec fetch_lyrics(%{}) :: [] | [String.t]
  defp fetch_lyrics(%{"lyrics" => "(Laughter)"}), do: []
  defp fetch_lyrics(%{"lyrics" => "(Instrumental)"}), do: []
  defp fetch_lyrics(%{"lyrics" => "(Solo)"}), do: []
  defp fetch_lyrics(%{"lyrics" => "(solo)"}), do: []
  defp fetch_lyrics(%{"lyrics" => "Instrumental"}), do: []
  defp fetch_lyrics(%{"lyrics" => "Not found"}), do: []
  defp fetch_lyrics(%{"url" => song_url}) do
    with %HTTPotion.Response{body: html} <- HTTPotion.get(song_url, follow_redirects: true, timeout: 10_000)
    do
      html
      |> Floki.find(".lyricbox")
      |> Floki.text
      |> String.split("\n")
      |> sanitize_lyrics
    end
  end

  @spec song_title_looks_good?(String.t) :: boolean
  defp song_title_looks_good?(song_title) do
    !Regex.match?(@regex_colon_then_uppercase_letter, song_title)
    && !Regex.match?(@regex_hash_then_uppercase_letter, song_title)
    && !Regex.match?(@regex_surrounded_by_quotes, song_title)
  end

  @spec sanitize_lyrics([String.t]) :: [String.t]
  defp sanitize_lyrics(lyrics) do
    lyrics
    |> Enum.reduce([], &sanitize_lyrics/2)
    |> Enum.reverse
  end

  @doc """
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

  @spec fetch_song_info(String.t, String.t) :: %HTTPotion.Response{}
  defp fetch_song_info(artist, song) do
    HTTPotion.get(@api_url, query: query_params(artist: artist, song: song, action: "lyrics"))
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

  @spec decode_json(%HTTPotion.Response{}) :: %{}
  defp decode_json(httpotion_response) do
    with %HTTPotion.Response{status_code: 200, body: json} <- httpotion_response,
         {:ok, data} <- Poison.decode(json)
    do
      data
    end
  end

  @spec query_params([{atom, any}]) :: %{}
  defp query_params(params) do
    params
    |> Enum.into(%{fmt: "realjson"})
  end

end
