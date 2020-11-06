require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExpenseTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.autoload_paths << 'app/models/recurrence_rule'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.generators do |g|
      # g.orm false
      g.scaffold_stylesheet false
      g.assets false
      g.helper false
      # g.test_framework  false
    end
  end
end
