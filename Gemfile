source "https://rubygems.org"

ruby "3.2.2" # ﾃｷｽﾄと違うver.
gem "rails", "~> 7.1.2" # ﾃｷｽﾄと違うver.
gem 'bcrypt' # has_secure_passwordを使って、ﾊﾟｽﾜｰﾄﾞをﾊｯｼｭ化するため必要
gem 'faker'
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "sassc-rails"
gem 'bootstrap-sass', '3.3.6'
gem 'jquery-rails'
gem 'will_paginate', '~> 3.3'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'rails-i18n' # 日本語化

group :development, :test do
  gem "debug", platforms: %i[ mri windows ] # ﾃｷｽﾄと違う
end

group :development do
  gem "web-console"
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rails-flog', require: 'flog'
  gem 'rspec-rails'
  gem "factory_bot_rails"
  gem 'faker'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

gem "tzinfo-data", platforms: %i[ windows jruby ] # テキストと違う