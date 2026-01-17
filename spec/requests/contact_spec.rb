# spec/requests/contact_spec.rb
# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'contact', type: :request do
  before { get '/contact' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/Contact/i) }
end

RSpec.describe 'contact/new', type: :request do
  context 'when no params are provided' do
    before do
      params = { name: '',
                 email: '',
                 phone: '',
                 message: '' }
      post '/contact/new', params
    end
    subject(:response) { last_response }

    its(:status) { is_expected.to eq(200) }
    its(:body)   { is_expected.to match(/Error/i) }
  end

  context 'when params are provided' do
    before do
      params = { name: Faker::Name.name,
                 email: Faker::Internet.email,
                 phone: Faker::PhoneNumber.phone_number,
                 message: Faker::Lorem.sentence }
      post '/contact/new', params
    end

    subject(:response) { last_response }

    its(:status) { is_expected.to eq(303) }
  end
  context 'when honeypot params are provided' do
    before do
      params = { name: Faker::Name.name,
                 email: Faker::Internet.email,
                 phone: Faker::PhoneNumber.phone_number,
                 message: Faker::Lorem.sentence,
                 company: 'spam' }
      post '/contact/new', params
    end

    subject(:response) { last_response }

    its(:status) { is_expected.to eq(200) }
    its(:body)   { is_expected.to match(/Error/i) }
  end
end

RSpec.describe 'contact/thank_you', type: :request do
  before { get '/contact/thank_you' }

  subject(:response) { last_response }

  its(:status) { is_expected.to eq(200) }
  its(:body)   { is_expected.to match(/Thank You/i) }
end
