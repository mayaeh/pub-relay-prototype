require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Rails.load

require_relative "../lib/redis/namespace_extensions"

module PubRelay
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Explicitly set the cache format version to align with Rails version
    config.active_support.cache_format_version = 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w(assets tasks templates generators))
    # TODO: We should enable this eventually, but for now there are many things
    # in the wrong path from the perspective of zeitwerk.

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    Rails.application.default_url_options[:host]     = ENV.fetch('DOMAIN') { "localhost:#{ENV.fetch('PORT', 3000)}" }
    Rails.application.default_url_options[:protocol] = ENV['HTTPS'] == 'true' ? 'https' : 'http'

    config.before_configuration do
      require 'pubrelay/redis_config'
    end
  end
end
