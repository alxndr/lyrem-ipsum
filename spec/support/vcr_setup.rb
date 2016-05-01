require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/recordings'
  config.default_cassette_options = { record: :none }
  config.hook_into :webmock
end
