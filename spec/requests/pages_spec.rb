# frozen_string_literal: true

require_relative '../rack_helper'

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

RSpec.describe 'Legacy Pages Redirect', type: :feature do
  [
    '/artwork-specs.html',
    '/colors.html',
    '/fonts.html',
    '/leather-patches.html',
    '/monograms.html',
    '/privacy-policy.html',
    '/sms-policy.html',
    '/terms-of-service.html'
  ].each do |path|
    describe "GET #{path}" do
      before { get path }

      subject(:response) { last_response }

      its(:status) { is_expected.to eq(302) }
    end
  end
end

RSpec.describe 'Web Pages', type: :feature do
  ['/',
   '/about',
   '/artwork-specs',
   '/colors',
   '/fonts',
   '/leather-patches',
   '/monograms',
   '/privacy-policy',
   '/robots.txt',
   '/sms-policy',
   '/terms-of-service'].each do |path|
    describe "GET #{path}" do
      before { get path }

      subject(:response) { last_response }

      its(:status) { is_expected.to eq(200) }
      # its(:body)   { is_expected.to match(/#{path}/i) }
    end
  end
end

RSpec.describe 'page not found', type: :request do
  before { get '/page-not-found' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(404) }
end
