# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

# Rack LiveReload middleware # TODO: move to `config/environments/development.rb`
if ENV['RACK_ENV'] == 'development'
  require 'rack-livereload'
  use Rack::LiveReload
end

# Rack MiniProfiler middleware # TODO: move to `config/environments/development.rb`
# if ENV['RACK_ENV'] == 'development'
#   require 'rack-mini-profiler'
#   Rack::MiniProfiler.config.position = 'right'
#   use Rack::MiniProfiler
# end

require 'active_support/all'

Dir.glob('config/initializers/*.rb').each { |f| require_relative f }
require_relative 'app'

run RodeoApp
