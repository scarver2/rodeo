# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'healthz', type: :request do
  it 'returns ok (if the endpoint exists)' do
    get '/healthz'

    skip "No /healthz route found (safe to ignore if you haven't added it yet)." if last_response.status == 404

    expect(last_response.status).to eq(200)
    expect(last_response.body).to match(/ok/i)
  end
end
