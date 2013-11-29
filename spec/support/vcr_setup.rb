require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/recordings'
  config.hook_into :webmock
end
