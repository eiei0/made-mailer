# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "bootsnap", require: false
gem "browser-timezone-rails", "~> 1.0.1"
gem "devise", "~> 4.3.0"
gem "jbuilder", "~> 2.5"
gem "mail", "~> 2.7.0"
gem "money-rails", "~> 1.7.0"
gem "pg", "~> 0.18"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.4"
gem "sass-rails", "~> 5.0"
gem "sentry-raven"
gem "sidekiq", "~> 5.0.5"
gem "sidekiq-scheduler", "~> 2.1.10"
gem "square_connect", "~>2.5.0.180"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "uglifier", ">= 1.3.0"
gem "webpacker", "~> 3.5"

group :development, :test do
  gem "capybara", "~> 2.13"
  gem "dotenv-rails"
  gem "faker"
  gem "figaro"
  gem "pry-rails"
  gem "rubocop", require: false
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "factory_bot_rails", "~> 4.0"
  gem "rake"
  gem "rspec-rails"
  gem "timecop"
end
