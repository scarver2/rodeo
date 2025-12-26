# frozen_string_literal: true

require 'sinatra/base'

# The entry point for the application
class RodeoApp < Sinatra::Base
  get '/' do
    erb :home
  end

  get '/healthz' do
    'ok'
  end
end
