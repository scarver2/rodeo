# app.rb
# frozen_string_literal: true

LEGACY_PAGES = %w[
  privacy-policy
  sms-policy
  terms-of-service
  colors
  fonts
  monograms
  leather-patches
  artwork-specs
].freeze

PAGES = LEGACY_PAGES + %w[
  about
  services
].freeze

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
    @form = ContactForm.new({})
    erb :contact
  end

  post '/contact/new' do
    @form = ContactForm.new(params)
    if @form.valid?
      ContactMailer.new(@form).deliver
      redirect '/contact/thank_you', RedirectStatus::POST_TO_GET
    else
      erb :contact
    end
  end

  get '/contact/thank_you' do
    erb :thank_you
  end

  # redirects legacy *.html pages to new pages
  LEGACY_PAGES.each do |path|
    get "/#{path}.html" do
      redirect to(path), RedirectStatus::PERMANENT
    end
  end

  # renders pages
  PAGES.each do |path|
    get "/#{path}" do
      erb path.underscore.to_sym
    end
  end

  not_found do
    status 404
    erb :'404', layout: false
  end

  error do
    status 500
    erb :'500', layout: false
  end
end
