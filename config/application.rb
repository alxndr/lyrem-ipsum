require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

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

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # "Due to a change in Rails that prevents images from being compiled in vendor and lib, you'll
    # need to add the following line to your application.rb:"
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

  end
end
