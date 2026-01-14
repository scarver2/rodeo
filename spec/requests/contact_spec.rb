# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'contact', type: :request do
  before { get '/contact' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/Contact/i) }
end
