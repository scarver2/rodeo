# spec/requests/error_500_spec.rb
# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'page errors', type: :request do
  before do
    # Ensure Sinatra does NOT re-raise exceptions in test,
    # so the `error do ... end` handler actually runs.
    app.set :raise_errors, false
    app.set :show_exceptions, false
    app.set :dump_errors, false
  end

  it 'returns 500 and renders the 500 template without layout' do
    # Make rendering explode for the *normal* route template,
    # but allow the error handler's 500 template to render.
    allow_any_instance_of(Sinatra::Base).to receive(:erb).and_wrap_original do |orig, template, *args, **kwargs|
      raise StandardError, 'erb blew up' unless template.to_s == '500'

      orig.call(template, *args, **kwargs)
    end

    get '/'

    expect(last_response.status).to eq(500)
    expect(last_response.body).to include('Error Occurred')
  end
end
