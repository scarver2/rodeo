# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'contact', type: :request do
  before { get '/contact' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/Contact/i) }
end

RSpec.describe 'contact/new', type: :request do
  before { post '/contact/new' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(302) }
  # its(:body)   { is_expected.to match(/Thank You/i) }
end

RSpec.describe 'contact/thank_you', type: :request do
  before { get '/contact/thank_you' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/Thank You/i) }
end
