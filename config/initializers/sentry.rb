Raven.configure do |config|
  config.dsn = 'https://034c0daf941f4d18a149c0cdfaed2d80:f3ee0ffc614a46318f763ca3f2c2123a@sentry.io/254619'
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
