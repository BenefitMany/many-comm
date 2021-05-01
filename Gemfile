source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby Version
ruby '2.6.6'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

# Framework
gem 'active_model_serializers', '~> 0.10.12'
gem 'awrence'
gem 'bcrypt'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '4.3.1'
gem 'coffee-rails', '~> 4.2'
gem 'figaro'
gem 'font-awesome-rails'
gem 'haml'
gem 'haml-rails'
gem 'postgresql'
gem 'rails', '~> 5.2.1'
gem 'sass-rails', '~> 5.0'
gem 'kaminari', '1.2.1' # Usint will_paginate
gem 'foreman', '~> 0.84.0'
gem 'mina', '1.0.6'
gem 'mina-whenever'
gem 'mini_magick'
gem 'money-rails'
gem 'faker'
gem 'net-sftp', '~> 3.0.0'
gem 'net-ssh', '~> 5.2.0'
gem 'nokogiri', '1.11.0'
gem 'pg'
gem 'plissken'
gem 'puma', '~> 3.12'
# gem 'rails-ujs', '~> 5.1.0.beta1'
gem 'rack-cors'
gem 'redis' , '~> 4.2.5'
gem 'resque'
gem 'resque-scheduler'
gem 'resque-web', require: 'resque_web'
gem 'scoped_search'
gem 'sendgrid-ruby'
gem 'twilio-ruby', '5.46.1'
gem 'typhoeus'
gem 'uglifier', '>= 1.3.0'
gem 'virtus'
gem 'webpacker', '~> 3.0'
gem 'whenever', require: false

# Environment Specific configuration
group :development, :test do
  gem 'factory_bot_rails'
  gem 'forgery'
  gem 'fuubar'
  gem 'pdf-inspector'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rails_best_practices', require: false
  gem 'rdoc'
  gem 'rspec-benchmark'
  gem 'rspec-nc'
  gem 'rspec-rails'
  gem 'rspec_api_documentation'
  gem 'rspec_junit_formatter'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'to_factory'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'mocha'
  gem 'mock_redis'
  gem 'response_code_matchers'
  gem 'rspec-activejob'
  gem 'resque_spec', '~> 0.18.1'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'stripe-ruby-mock', '~> 2.5.4', require: 'stripe_mock'
  gem 'timecop'
  gem 'twilio_mock'
  gem 'webmock'
  # gem 'zonebie'
end
