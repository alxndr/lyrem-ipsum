module CustomArray

  def join_avoiding_dupe_punctuation(glue)
    reduce('') do |memo, obj|
      "#{memo}#{glue if /[a-z]$/i.match(memo)} #{obj}"
    end
  end

end
