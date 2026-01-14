# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'home', type: :request do
  before { get '/' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   do
    skip 'TODO: confirm content renders'
    is_expected.to match(/Welcome/i)
  end
end

RSpec.describe 'robots.txt', type: :request do
  before { get '/robots.txt' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/robots.txt/i) }
end

# frozen_string_literal: true

RSpec.describe 'Legal Pages', type: :feature do
  describe 'GET /privacy-policy' do
    before { get '/privacy-policy' }

    subject(:response) { last_response }

    its(:status) { is_expected.to eq(200) }
    its(:body)   { is_expected.to match(/Privacy Policy/i) }
  end

  describe 'GET /terms-of-service' do
    before { get '/terms-of-service' }

    subject(:response) { last_response }

    its(:status) { is_expected.to eq(200) }
    its(:body)   { is_expected.to match(/Terms of Service/i) }
  end
end
