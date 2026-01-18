# spec/requests/healthz_spec.rb
# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'healthz', type: :request do
  before { get '/healthz' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/OK/i) }
end
