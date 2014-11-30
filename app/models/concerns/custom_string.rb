module CustomString

  REGEX_BRACKETS_AND_CONTENTS = %r{\[.*\]}
  REGEX_FIRST_LETTER          = %r{([^\s\d[:punct:]])}i
  REGEX_HTML_TAG_AND_CONTENTS = %r{<[^>]*>.*?</[^>]*>}
  REGEX_HTML_SELF_CLOSING_TAG = %r{<[^>]*>}

  def capitalize_first_letter
    sub(REGEX_FIRST_LETTER) { $1.mb_chars.capitalize.to_s }
  end

  def looks_like_cover_song?
    match %r{[a-z]:[A-Z]}
  end

  def sanitize_lyric
    gsub(REGEX_BRACKETS_AND_CONTENTS, '').
      gsub(REGEX_HTML_TAG_AND_CONTENTS, '').
      gsub(REGEX_HTML_SELF_CLOSING_TAG, '').
      strip
  end

  def to_slug
    strip.
      downcase.
      gsub(/['`]/, '').       # ignore apostrophes
      gsub('&', ' and ').     # expand abbreviations
      gsub(/[^a-z0-9]/, '-'). # hyphenate
      gsub(/-+/, '-').        # collapse duplicates
      gsub(/^-*|-*$/, '')     # trim ends
  end

  def valid_lyric?
    present? &&
      length < 100 &&
      index(/[a-z]/i) &&
      !index(/\b(not found|instrumental|transcribed|copyright|chorus)\b/i)
  end

end
