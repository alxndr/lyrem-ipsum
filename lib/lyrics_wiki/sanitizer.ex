defmodule LyricsWiki.Sanitizer do
  @defmodule """
  Holds functions for filtering and sanitizing raw data.
  """

  @regex_author ~r/^by [A-Z][a-z]/
  @regex_brackets ~r/^\[.+\]$/
  @regex_chorus ~r/^\[?(Bridge|Chorus):?\]?$/
  @regex_colon_then_uppercase_letter ~r/\w:[A-Z]/
  @regex_copyright ~r/(©|\(c\)|copyright)/i
  @regex_hash_then_uppercase_letter ~r/\w#[A-Z]/
  @regex_junk_around_match ~r/[\s]*(?<content>.+?)[\s;,.]*$/
  @regex_laughter ~r/\(Laughter\)/
  @regex_name_of_speaker_followed_by_colon ~r/^[A-Z][a-zA-Z'?-]+( #\d)?: /
  @regex_name_with_instrument_in_parens ~r/^([a-zA-Z'\-"]+ ){2,4}\([a-z, ]+\)$/
  @regex_number_of_times_in_parens ~r/^\(\d+ times\)$/
  @regex_repetition_indicator ~r/\s?[\(\[](x\d+|\d+x|\d+ times?)[\)\]]/
  @regex_surrounded_by_quotes ~r/^"[^"]+"$/

  @spec sanitize_lyrics([String.t]) :: [String.t]
  def sanitize_lyrics(lyrics) do
    lyrics
    |> Enum.reduce([], &sanitize_lyrics/2)
    |> Enum.reverse
  end

  @spec song_title_looks_good?(String.t) :: boolean
  def song_title_looks_good?(song_title) do
    !Regex.match?(@regex_colon_then_uppercase_letter, song_title)
    && !Regex.match?(@regex_hash_then_uppercase_letter, song_title)
    && !Regex.match?(@regex_surrounded_by_quotes, song_title)
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
      Regex.match?(@regex_brackets, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_author, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_chorus, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_copyright, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_laughter, lyric) ->
        sanitized_lyrics
      Regex.match?(@regex_name_with_instrument_in_parens, lyric) ->
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

end