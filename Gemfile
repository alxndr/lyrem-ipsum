ruby '2.2.1'

source 'https://rubygems.org'

gem 'airbrake'
gem 'arel'
gem 'bitters'
gem 'bugsnag'
gem 'google-search'
gem 'htmlentities'
gem 'lyriki'
gem 'neat'
gem 'newrelic_rpm', '>= 3.5.3.25'
gem 'nokogiri'
gem 'pg'
gem 'rails', '~> 4.2.1'
gem 'requirejs-rails'
gem 'sass-rails', '~> 4.0.3' # http://stackoverflow.com/a/22395250/303896
gem 'skylight'
gem 'uglifier'

group :production, :staging do
  gem 'rails_log_stdout', github: 'heroku/rails_log_stdout' # for heroku
  gem 'rails_12factor' # for heroku
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets' # for heroku
  gem 'unicorn'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'capybara'
  gem 'colorize'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'fuubar'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails', '~> 3.1'
  gem 'shoulda-matchers'
end

group :development do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-rspec'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'coveralls', require: false
  gem 'vcr'
  gem 'webmock'
end
