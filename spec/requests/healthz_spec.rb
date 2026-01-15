# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'healthz', type: :request do
  before do
    get '/healthz'
  end

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/OK/i) }
end
