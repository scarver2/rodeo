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

  # redirects legacy pages to new pages
  %w[privacy-policy
     sms-policy
     terms-of-service
     colors
     fonts
     monograms
     leather-patches
     artwork-specs].each do |path|
    get "/#{path}.html" do
      redirect to(path), 302
    end

    get "/#{path}" do
      erb path.underscore.to_sym
    end
  end

  %w[about].each do |path|
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
