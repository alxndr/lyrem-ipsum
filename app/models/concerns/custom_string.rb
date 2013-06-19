module CustomString

  def to_slug
    strip.
      downcase.
      gsub(/['`]/,'').       # ignore apostrophes
      gsub('&',' and ').     # expand abbreviations
      gsub(/[^a-z0-9]/,'-'). # hyphenate
      gsub(/-+/,'-').        # collapse duplicates
      gsub(/^-*|-*$/,'')     # trim ends
  end

  def valid_lyric?
    present? && index(/[a-z]/i) && !index(/(not found|instrumental|transcribed|copyright|chorus)/i)
  end

  def capitalize_first_letter
    sub(/([a-z])/i) { $1.capitalize }
  end

end
