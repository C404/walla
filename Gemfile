source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 and PostgreSQL as the databases for Active Record
gem 'sqlite3'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
gem 'debugger', '>= 1.6.5', group: [:development, :test]

gem 'devise'

gem 'omniauth'

group :development do
  # Deploy with Capistrano
  gem 'capistrano', '~> 2'
  gem 'capistrano-ext'
  gem 'rvm-capistrano' # supports rvm on new serv
  gem 'capistrano-thin', github: 'elthariel/capistrano-thin', :require => false
  gem 'meta_request', '0.2.1'

  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'quiet_assets'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker', github: 'stympy/faker'
  gem 'rspec-rails'
  gem 'simplecov', :require => false
  gem 'coveralls', require: false

  # Better rails console (and more)
  gem 'pry-rails'
end

gem 'databasedotcom'


# Configuration handling
gem 'figaro'

# Geolocation gems
gem 'geoip'
gem 'geocoder'

# Webserver
gem 'thin'

# Sferik's Twitter client
gem 'twitter'

# Easily create/manage daemons for stream schedulin
gem 'daemons-rails'

# Serialization
gem "active_model_serializers"

# ElascticSearch
gem 'tire'

# Sidekiq
gem 'sidekiq'

# Le meilleur des ActiveAdmin
gem 'activeadmin', github: 'gregbell/active_admin'

gem 'rest-client'


gem 'hashie'
