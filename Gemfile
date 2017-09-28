source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || RUBY_VERSION

gem 'rails', '4.2.9'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '>= 3.2.1'
  gem 'sass-rails',   '>= 3.2.3'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'guard-rspec'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'sqlite3'
end

group :test do
  # Uncomment this line on OS X.
  #gem 'growl'
  # Uncomment these lines on Linux.
  #gem 'libnotify'
  # Uncomment these lines on Windows.
  # gem 'rb-notifu'
  # gem 'win32console'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
end

gem 'active_model_serializers'
gem 'acts_as_list'
gem 'angularjs-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'libv8', '~> 3.16.14.19'
gem 'rake', '< 11.0'
gem 'simple_form'
gem 'slim-rails'
gem 'therubyracer'
gem 'twitter-bootstrap-rails'
gem 'underscore-rails'

group :test do
  if ENV['TRAVIS']
    gem 'mysql2'
    gem 'pg'
  end
end

group :deployment do
  gem 'pg'
end
