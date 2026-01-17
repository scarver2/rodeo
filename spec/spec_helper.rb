# spec/spec_helper.rb
# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require 'dotenv'
require 'faker'
require 'pry'
require 'rspec'
require 'rspec/its'
require 'simplecov' # TODO: if ENV['COVERAGE'] == 'true' || ENV['CI'] == 'true'

# Load test environment variables
Dotenv.overload('.env.test', '.env.test.local') # local overrides are handy

# Load all support helpers
Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.after { Timecop.return if defined?(Timecop) }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
