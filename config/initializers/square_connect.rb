require 'square_connect'

SquareConnect.configure do |config|
  config.access_token = ENV['square_api_token']
end
