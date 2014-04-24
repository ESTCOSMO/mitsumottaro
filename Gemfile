source 'https://rubygems.org'

gem 'rails', '4.1.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
if ENV['TRAVIS']
  gem "mysql2"
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '>= 3.2.3'
  gem 'coffee-rails', '>= 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spring'
  gem 'spring-commands-rspec'
  #  gem 'debugger'
end

group :test do
  # Uncomment this line on OS X.
  #gem 'growl'
  # Uncomment these lines on Linux.
  #gem 'libnotify'
  # Uncomment these lines on Windows.
  # gem 'rb-notifu'
  # gem 'win32console'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

gem 'acts_as_list'

gem 'twitter-bootstrap-rails'
gem 'therubyracer'
gem 'libv8', '~> 3.11.8'
gem 'less-rails'
gem 'haml-rails'
gem 'underscore-rails'
group :test do
  gem 'simplecov', require: false
end
