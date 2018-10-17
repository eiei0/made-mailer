# frozen_string_literal: true

require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module MadeAssistant
  # Rails
  class Application < Rails::Application
    config.load_defaults 5.1
    config.time_zone = "Central Time (US & Canada)"
    config.active_record.default_timezone = :local
  end
end
