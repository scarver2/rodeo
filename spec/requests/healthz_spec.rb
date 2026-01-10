# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'healthz', type: :request do
  before do
    get '/healthz'
  end

  it 'returns status code 200' do
    expect(last_response.status).to eq(200)
  end

  it 'returns OK' do
    expect(last_response.body).to match(/OK/i)
  end
end
