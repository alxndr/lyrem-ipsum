defmodule LyricsWiki.Api do

  @api_url "http://lyrics.wikia.com/api.php"

  @httpotion_options [follow_redirects: true, timeout: 12_000]

  @spec fetch_artist_info(String.t) :: %{}
  def fetch_artist_info(name) do
    query = query_params(func: "getArtist", artist: name)
    HTTPotion.get(@api_url, httpotion_options(query: query))
    |> decode_json
  end

  @spec fetch_lyrics(%{}) :: [] | [String.t]
  def fetch_lyrics(%{"lyrics" => "(Instrumental)"}), do: []
  def fetch_lyrics(%{"lyrics" => "(Solo)"}), do: []
  def fetch_lyrics(%{"lyrics" => "(solo)"}), do: []
  def fetch_lyrics(%{"lyrics" => "Instrumental"}), do: []
  def fetch_lyrics(%{"lyrics" => "Not found"}), do: []
  def fetch_lyrics(%{"url" => song_url}) do
    with %HTTPotion.Response{body: html} <- HTTPotion.get(song_url, httpotion_options)
      do
      html
      |> Floki.find(".lyricbox")
      |> Floki.text
      |> String.split("\n")
    end
  end

  @spec fetch_song_info(String.t, String.t) :: %HTTPotion.Response{}
  def fetch_song_info(artist, song) do
    query = query_params(artist: artist, song: song, action: "lyrics")
    HTTPotion.get(@api_url, httpotion_options(query: query))
    |> decode_json
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

  defp httpotion_options(options_list \\ []) do
    options_list ++ @httpotion_options
  end

end
