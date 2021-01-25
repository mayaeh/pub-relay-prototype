source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 2.4.0', '< 2.7.0'

gem 'rails', '~> 5.2.4'
gem 'sprockets', '~> 3.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.1'

gem 'oj'
gem 'http'
gem 'addressable'
gem 'sidekiq'
gem 'sidekiq-bulk'
gem 'dotenv-rails'
gem 'hiredis', '~> 0.6'
gem 'nokogiri'
gem 'redis-namespace', '~> 1.8'
gem 'redis', '~> 4.2', require: ['redis', 'redis/connection/hiredis']
gem 'redis-rails'
gem 'fast_blank'

gem 'bootsnap', '>= 1.4', require: false

group :development, :test do
  gem 'byebug'
  gem 'fuubar'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-sidekiq'
end

group :production do
  gem 'lograge'
end

gem 'tzinfo-data', '~> 1.2021'
