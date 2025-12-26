# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require 'rspec'

if ENV['COVERAGE'] == 'true' || ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    enable_coverage :branch
    add_filter '/spec/'
  end

  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

  # minimum coverage threshold
  SimpleCov.minimum_coverage 90
end

RSpec.configure do |config|
  config.after { Timecop.return if defined?(Timecop) }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
