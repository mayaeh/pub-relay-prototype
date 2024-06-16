source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 3.0.0'

gem 'rails', '~> 7'
gem 'sprockets', '~> 4.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 6.4'

gem 'oj'
gem 'http'
gem 'addressable'
gem 'sidekiq', '~> 6.5'
gem 'sidekiq-bulk', '~> 0.2.0'
gem 'sidekiq-scheduler', '~> 5.0'
gem 'sidekiq-unique-jobs', '~> 7.1'
gem 'dotenv'
gem 'nokogiri'
gem 'hiredis', '~> 0.6'
gem 'redis-namespace', '~> 1.10'
gem 'redis', '~> 5.1'
gem 'fast_blank'

gem 'bootsnap', '>= 1.4', require: false

group :development, :test do
  gem 'byebug'
  gem 'fuubar'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.10'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'rspec-sidekiq'
end

group :production do
  gem 'lograge'
end

gem 'tzinfo-data', '~> 1.2024'

gem 'resolv', '~> 0.3.0'
