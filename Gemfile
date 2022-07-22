source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.0.2"

gem "active_storage_validations", "0.8.2"
gem "bcrypt", "3.1.13"
gem "bootstrap-sass", "3.4.1"
gem "ckeditor", github: "galetahub/ckeditor"
gem "cocoon"
gem "config"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "jquery-rails", "4.3.1"
gem "rails", "~> 6.1.6"
# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"
# Use Puma as the app server
gem "i18n-js"
gem "image_processing", "1.9.3"
gem "mini_magick", "4.9.5"
gem "puma", "~> 5.0"
gem "rails-i18n"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
gem "faker", "~> 2.12"
# Use Active Storage variant
# gem "image_processing", "~> 1.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false
gem "pagy"

group :development do
  gem "bullet"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "database_cleaner", "~> 1.5"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webdrivers"
end

group :development, :test do
  gem "factory_bot_rails"
  gem "pry-nav"
  gem "pry-rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
