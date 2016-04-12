ruby '2.2.1'

source 'https://rubygems.org'

gem 'arel', '~> 6.0'
gem 'bitters', '~> 0.10'
gem 'google-search', '~> 1.0'
gem 'htmlentities', '~> 4.3'
gem 'lyriki', '~> 1.0', '>= 1.0.1'
gem 'neat', '~> 1.5'
gem 'newrelic_rpm', '~> 3.9', '>= 3.5.3.25'
gem 'nokogiri', '~> 1.6', '>= 1.6.7.2'
gem 'pg', '~> 0.17'
gem 'rack', '~> 1.6', '>= 1.6.2'
gem 'rails', '~> 4.2', '>= 4.2.5.1'
gem 'rails-html-sanitizer', '~> 1.0', '>= 1.0.3'
gem 'requirejs-rails', '~> 0.9'
gem 'rest-client', '~> 1.8', '>= 1.8.0'
gem 'sass-rails', '~> 4.0', '>= 4.0.3' # http://stackoverflow.com/a/22395250/303896
gem 'uglifier', '~> 2.7', '>= 2.7.2'

group :production, :staging do
  gem 'airbrake', '~> 4.3'
  gem 'bugsnag', '~> 2.5'
  gem 'rails_12factor', '~> 0.0' # for running on heroku
  gem 'skylight', '~> 0.7'
  gem 'unicorn', '~> 4.8'
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
  gem 'vcr', '~> 2.9.3'
  gem 'webmock'
end
