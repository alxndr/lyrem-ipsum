ruby '2.2.1'

source 'https://rubygems.org'

gem 'airbrake', '~> 4.3'
gem 'arel', '~> 6.0'
gem 'bitters', '~> 0.10'
gem 'bugsnag', '~> 2.5'
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
  gem 'rails_12factor', '~> 0.0' # for running on heroku
  gem 'skylight', '~> 0.7'
  gem 'unicorn', '~> 4.8'
end

group :development, :test do
  gem 'brakeman', '~> 2.6', require: false
  gem 'capybara', '~> 2.4'
  gem 'colorize', '~> 0.7'
  gem 'factory_girl', '~> 4.5'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'fuubar', '~> 2.0'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'rspec-rails', '~> 3.1'
  gem 'shoulda-matchers', '~> 2.7'
end

group :development do
  gem 'awesome_print', '~> 1.2'
  gem 'better_errors', '~> 2.0'
  gem 'binding_of_caller', '~> 0.7'
  gem 'guard', '~> 2.10'
  gem 'guard-rails', '~> 0.7'
  gem 'guard-rspec', '~> 4.5'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 0.4', require: false
  gem 'coveralls', '~> 0.7', require: false
  gem 'vcr', '~> 2.9'
  gem 'webmock', '~> 1.20'
end
