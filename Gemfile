source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 2.5.0', '< 3.0.0'

gem 'rails', '~> 7.1.1'
gem 'sprockets', '~> 3.7.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.6'

gem 'oj'
gem 'http'
gem 'addressable'
gem 'sidekiq'
gem 'sidekiq-bulk'
gem 'dotenv-rails'
gem 'hiredis', '~> 0.6'
gem 'nokogiri'
gem 'redis-namespace', '~> 1.10'
gem 'redis', '~> 4.5', require: ['redis', 'redis/connection/hiredis']
gem 'redis-rails'
gem 'fast_blank'

gem 'bootsnap', '>= 1.4', require: false

group :development, :test do
  gem 'byebug'
  gem 'fuubar'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.9'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-sidekiq'
end

group :production do
  gem 'lograge'
end

gem 'tzinfo-data', '~> 1.2023'

gem 'resolv', '~> 0.2.2'
