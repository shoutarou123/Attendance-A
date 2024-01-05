source "https://rubygems.org"

ruby "3.2.2" # ﾃｷｽﾄと違うver.
gem "rails", "~> 7.1.2" # ﾃｷｽﾄと違うver.
gem 'bcrypt' # has_secure_passwordを使って、ﾊﾟｽﾜｰﾄﾞをﾊｯｼｭ化するため必要
gem 'bootstrap-sass'
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ] # ﾃｷｽﾄと違う
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "tzinfo-data", platforms: %i[ windows jruby ] # テキストと違う