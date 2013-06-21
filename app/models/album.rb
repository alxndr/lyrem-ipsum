class Album < ActiveRecord::Base

  attr_accessor :name

  belongs_to :artist

end
