# frozen_string_literal: true

MAILER_SETTINGS = Hash[
  address: "smtp.zoho.com",
  port: 465,
  user_name: ENV["wholesale_email"],
  domain: "madelr.com",
  password: ENV["zoho_password"],
  authentication: "plain",
  ssl: true,
  tls: true,
  enable_starttls_auto: true]

Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
config.webpacker.check_yarn_integrity = false

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.read_encrypted_secrets = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options =
    { host: "made-assistant.heroku.com" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = MAILER_SETTINGS
  config.action_mailer.default_options = { from: ENV["wholesale_email"] }
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
end
