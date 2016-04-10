ruby '2.2.1'

source 'https://rubygems.org'

gem 'airbrake', '~> 4.1.0' # TODO move to prod/stag only
gem 'arel', '~> 6.0.3'
gem 'bitters', '~> 0.10.1'
gem 'bugsnag', '~> 2.5.1'
gem 'google-search', '~> 1.0.3'
gem 'htmlentities', '~> 4.3.2'
gem 'lyriki', '~> 1.0.1'
gem 'neat', '~> 1.5.1'
gem 'newrelic_rpm', '>= 3.5.3.25', '~> 3.9.7.266'
gem 'nokogiri', '>= 1.6.7.2', '~> 1.6.7.2'
gem 'pg', '~> 0.17.1'
gem 'rails', '~> 4.2.5.1'
gem 'requirejs-rails', '~> 0.9.5'
gem 'sass-rails', '~> 4.0.3' # http://stackoverflow.com/a/22395250/303896
gem 'skylight', '~> 0.6.0' # TODO move to prod/stag only
gem 'uglifier', '>= 2.7.2', '~> 2.7.2'

gem 'rack', '>= 1.6.2', '~> 1.6.4'
gem 'rest-client', '>= 1.8.0', '~> 1.8.0'
gem 'rails-html-sanitizer', '~> 1.0.3'

group :production, :staging do
  gem 'rails_log_stdout', '~> 0.0.1', github: 'heroku/rails_log_stdout' # for heroku
  gem 'rails_12factor', '~> 0.0.3' # for heroku
  gem 'rails3_serve_static_assets', '~> 0.0.1', github: 'heroku/rails3_serve_static_assets' # for heroku
  gem 'unicorn', '~> 4.8.3'
end

group :development, :test do
  gem 'brakeman', '~> 2.6.3', require: false
  gem 'capybara', '~> 2.4.4'
  gem 'colorize', '~> 0.7.3'
  gem 'factory_girl', '~> 4.5.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'fuubar', '~> 2.0.0'
  gem 'rspec-activemodel-mocks', '~> 1.0.1'
  gem 'rspec-rails', '~> 3.1'
  gem 'shoulda-matchers', '~> 2.7.0'
end

group :development do
  gem 'awesome_print', '~> 1.2.0'
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'guard', '~> 2.13'
  gem 'guard-rails', '~> 0.7.0'
  gem 'guard-rspec', '~> 4.5.0'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 0.4.1', require: false
  gem 'coveralls', '~> 0.7.1', require: false
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.20.4'
end
