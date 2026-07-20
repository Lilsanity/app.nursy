require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module AppNursy
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end

    config.load_defaults 8.1
    config.i18n.available_locales = [:en, :fr]
    config.i18n.default_locale = :fr

    config.autoload_lib(ignore: %w[assets tasks])

  end
end
