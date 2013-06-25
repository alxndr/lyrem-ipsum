class Song < ActiveRecord::Base

  attr_accessor :name
  attr_accessor :lyrics

  belongs_to :album
  # has one artist through album ?

end