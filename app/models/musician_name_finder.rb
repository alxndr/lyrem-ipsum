require 'htmlentities'

class MusicianNameFinder

  class UnknownArtistError < StandardError; end

  def self.look_up(input)
    raise UnknownArtistError unless input && input.present?

    result = Google::Search::Web.new(query: "#{input} musician site:en.wikipedia.org").first

    raise UnknownArtistError unless result && result.title

    HTMLEntities.new.decode result.title.chomp(' - Wikipedia, the free encyclopedia')
  end

end
