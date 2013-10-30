module CustomArray

  def join_after_regex(opts)
    raise ArgumentError unless opts.has_key?(:glue) && opts.has_key?(:regex)

    anchored_regex = Regexp.new(opts[:regex].to_s + '$')

    reduce(String.new) do |memo, obj|
      "#{memo}#{opts[:glue] if memo.match(anchored_regex)} #{obj}"
    end
  end

end
