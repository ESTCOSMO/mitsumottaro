source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || RUBY_VERSION

gem 'rails', '4.2.9'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '>= 3.2.1'
  gem 'sass-rails',   '>= 3.2.3'
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
gem 'puma'
gem 'rake', '< 11.0'
gem 'simple_form'
gem 'slim-rails'
gem 'twitter-bootstrap-rails'
gem 'underscore-rails'

group :test do
  if ENV['TRAVIS']
    # see https://qiita.com/oshin/items/f5ff336f63366c364909
    gem 'mysql2', '~> 0.3.20'
  end
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end
