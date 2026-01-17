# config.ru
# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require 'dotenv'
Dotenv.load('.env', '.env.local') # or Dotenv.overload if you want it to win

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

require 'pry' if %w[development test].include?(ENV['RACK_ENV'])

require 'active_support/all'

Dir.glob('lib/*.rb').each { |f| require_relative f }
Dir.glob('config/initializers/*.rb').each { |f| require_relative f }
require_relative 'app'

run RodeoApp
