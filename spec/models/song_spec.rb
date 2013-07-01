require 'spec_helper'

describe Song do

  it { should belong_to :artist }
  it { should validate_presence_of :artist }

end
