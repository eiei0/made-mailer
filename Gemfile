source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'browser-timezone-rails', '~> 1.0.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery'
  gem 'rails-assets-bootstrap-sass', '~> 3.3.1'
  gem 'rails-assets-bootstrap-social', '~> 4.8.0'
  gem 'rails-assets-datatables', '~> 1.10.4'
  gem 'rails-assets-datatables-plugins', '~> 1.0.1'
  gem 'rails-assets-datatables-responsive', '~> 1.0.3'
  gem 'rails-assets-flot', '~> 0.8.3'
  gem 'rails-assets-flot.tooltip', '~> 0.8.4'
  gem 'rails-assets-font-awesome', '~> 4.2.0'
  gem 'rails-assets-holderjs', '~> 2.4.1'
  gem 'rails-assets-metisMenu', '~> 1.1.3'
  gem 'rails-assets-morrisjs', '~> 0.5.1'
end

gem 'sentry-raven'

gem 'devise', '~> 4.3.0'
gem 'sidekiq', '~> 5.0.5'
gem 'mailgun-ruby', '~>1.1.6'

gem 'square_connect', '~>2.5.0.180'

gem 'chartkick', '~> 1.4.2'
gem 'groupdate', '~> 2.5.3'
gem 'money-rails', '~> 1.7.0'

group :development, :test do
  gem 'pry-rails'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'figaro'
  gem 'faker'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails', '~> 4.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
