class MusicianNameFinder

  def self.look_up(input)
    raise unless input && input.present?

    result = Google::Search::Web.new(query: "#{input} musician site:en.wikipedia.org").first

    raise 'artist name not found' unless result && result.title

    result.title.chomp(' - Wikipedia, the free encyclopedia')
  end

end
