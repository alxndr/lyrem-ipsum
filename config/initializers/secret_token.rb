# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Uses a file called secret.token which holds the token
# We utilize a rake task - generate_secret_token - to generate this file if it doesn't exist
# from https://github.com/jasonshen/RewardBox/pull/3/files
if Rails.env.production?
  abort 'No secret token found. Run export SECRET_TOKEN=$(rake secret) before starting server. Aborting' unless ENV['SECRET_TOKEN']
  LyremIpsum::Application.config.secret_token = ENV['SECRET_TOKEN']
else
  token_file = Rails.root.join('config/secret.token')
  abort 'No config/secret.token file found. Please run "rake dev:generate_token". Aborting' unless token_file.exist?
  LyremIpsum::Application.config.secret_token = token_file.read
end
