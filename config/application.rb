require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module LyremIpsum
  class Application < Rails::Application

    #if Rails.env.development?
    #  # Update version file from latest git tag
    #  File.open('config/version', 'w') do |file|
    #    file.write `git describe --tags --always`
    #  end
    #end
    #config.version = File.read('config/version')

    # "Due to a change in Rails that prevents images from being compiled in vendor and lib, you'll
    # need to add the following line to your application.rb:"
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

  end
end
