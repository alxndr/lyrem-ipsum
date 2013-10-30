require 'securerandom'
require 'pathname'
require 'fileutils'

namespace :dev do

  desc 'Generate config/secret.token which is used for signing cookies'
  # Uses a file called secret.token which holds the token
  # We utilize a rake task - generate_token - to generate this file if it doesn't exist
  # from https://github.com/jasonshen/RewardBox/pull/3/files
  task :generate_token do
    secret_token_file = Rails.root.join('config', 'secret.token')
    secret_token_file.open('w') { |f| f << SecureRandom.hex(64) } unless secret_token_file.exist?
  end

end
