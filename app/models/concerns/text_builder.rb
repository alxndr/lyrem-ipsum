module TextBuilder

  def self.construct(constituent, min_length, max_length, joiner=nil)
    raise ArgumentError unless constituent.respond_to?(:call) && min_length >= 0 && min_length <= max_length
    list, attempts = [], 0

    length = min_length + rand(max_length - min_length)
    while list.length < length && attempts < 3 do # more rubyish way to do this?
      piece = constituent.call
      if piece == list.last # prevent repetition
        attempts += 1 # TODO there's an infinite loop here if all words/phrases are the same...
      else
        list.push(piece)
      end
    end

    retval = if joiner
               list.join(joiner)
             else
               list
             end

    if block_given?
      yield retval
    else
      retval
    end
  end

end

