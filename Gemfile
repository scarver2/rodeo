# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'activesupport', '~> 8.1'
gem 'mail', '~> 2.9'
gem 'puma', '~> 7.1'
gem 'rackup', '~> 2.3'
gem 'sinatra', '~> 4.2'
gem 'sinatra-contrib', '~> 4.2'

group :development do
  gem 'guard', require: false
  gem 'guard-bundler', require: false, github: 'scarver2/guard-bundler', branch: 'bundler-4'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false

  gem 'guard-livereload', require: false
  gem 'rack-livereload', require: false
  gem 'terminal-notifier-guard', '~> 1.7', require: false

  gem 'better_errors', require: false
  gem 'binding_of_caller', require: false
  gem 'debug', require: false
  gem 'rack-mini-profiler', require: false
  gem 'stackprof', require: false # optional, deeper profiling
end

group :development, :test do
  gem 'dotenv', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara', require: false
  gem 'faker', require: false
  gem 'parallel_tests', require: false # optional: big suite speed-up
  gem 'rack-test', require: false
  gem 'rspec', require: false
  gem 'rspec-its', require: false
  gem 'rspec_junit_formatter', require: false # optional: CI artifacts
  gem 'rspec-rails', require: false
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false # optional: CI-friendly XML
  gem 'timecop', require: false
end
