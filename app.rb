# frozen_string_literal: true

require 'sinatra/base'

# The entry point for the application
class RodeoApp < Sinatra::Base
  get '/' do
    "Howdy,  Y'all!"
  end

  get '/healthz' do
    'ok'
  end
end
