ruby '2.0.0'

source 'https://rubygems.org'

gem 'airbrake'
gem 'arel'
gem 'bitters'
gem 'google-search'
gem 'htmlentities'
gem 'jbuilder', '~> 1.0.1'
gem 'jquery-rails'
gem 'neat'
gem 'newrelic_rpm'
gem 'nokogiri'
gem 'pg'
gem 'rails', '~> 4.0'
gem 'sass-rails'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'

group :production, :staging do
  # for heroku
  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'capybara'
  gem 'colorize'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'fuubar'
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'launchy' # needed for capybara's save_and_open_page
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller' # dependency of better_errors
  gem 'debugger'
  gem 'guard'
end

group :test do
  gem 'coveralls', require: false
  gem 'vcr'
  gem 'webmock'
end

