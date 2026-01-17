# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require 'faker'
require 'rspec'
require 'rspec/its'
require 'simplecov' # TODO: if ENV['COVERAGE'] == 'true' || ENV['CI'] == 'true'

# Load all support helpers
Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.after { Timecop.return if defined?(Timecop) }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
