# frozen_string_literal: true

require 'sinatra/base'

# The entry point for the application
class RodeoApp < Sinatra::Base
  get '/' do
    erb :home
  end

  get '/healthz' do
    'OK'
  end

  get '/contact' do
    erb :contact
  end

  post '/contact/new' do
    redirect '/contact/thank_you'
  end

  get '/contact/thank_you' do
    erb :thank_you
  end

  get '/privacy-policy.html' do
    redirect to('/privacy-policy'), 302
  end

  get '/privacy-policy' do
    erb :privacy_policy
  end

  get '/sms-policy.html' do
    redirect to('/sms-policy'), 302
  end

  get '/sms-policy' do
    erb :sms_policy
  end

  get '/terms-of-service.html' do
    redirect to('/terms-of-service'), 302
  end

  get '/terms-of-service' do
    erb :terms_of_service
  end
end
