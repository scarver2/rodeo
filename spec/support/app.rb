# spec/support/app.rb
# frozen_string_literal: true

require 'rack/builder'

# Try to load a Rack app in a few common Rodeo layouts:
# 1) config.ru (Rack builder) — preferred
# 2) app.rb defining App < Sinatra::Base
# 3) Sinatra::Application fallback
APP = begin
  ru = File.expand_path('../../config.ru', __dir__)
  app_rb = File.expand_path('../../app.rb', __dir__)

  def parse_rackup_file(path)
    parsed = Rack::Builder.parse_file(path)
    parsed.is_a?(Array) ? parsed.first : parsed
  end

  def load_app_rb(path)
    require path if File.exist?(path)
  end

  def resolve_fallback_app
    if defined?(RodeoApp)
      RodeoApp
    elsif defined?(Sinatra::Application)
      Sinatra::Application
    else
      raise 'Could not find a Rack app. Expected config.ru or app.rb defining `App < Sinatra::Base`'
    end
  end

  if File.exist?(ru)
    parse_rackup_file(ru)
  else
    load_app_rb(app_rb)
    resolve_fallback_app
  end
end
