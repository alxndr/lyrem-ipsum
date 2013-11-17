require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module LyremIpsum
  class Application < Rails::Application

    # "Due to a change in Rails that prevents images from being compiled in vendor and lib, you'll
    # need to add the following line to your application.rb:"
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

  end
end
