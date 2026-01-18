# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'support/app'
require 'capybara/rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  # Configure Capybara for feature tests
  config.before(:each, type: :feature) do
    Capybara.default_driver = :rack_test
    Capybara.app = APP
  end

  # Rack::Test expects an `app` method.
  def app
    APP
  end

  config.filter_gems_from_backtrace 'rack', 'capybara', 'sinatra', 'rspec'
end
