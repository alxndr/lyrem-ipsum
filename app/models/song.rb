class Song < ActiveRecord::Base

  attr_accessor :name
  attr_accessor :lyrics

  belongs_to :artist

  validates :artist, presence: true

end