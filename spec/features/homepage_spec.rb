# spec/features/homepage_spec.rb
# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'Homepage', type: :feature do
  before do
    visit '/'
  end

  it 'returns status code 200' do
    expect(page.status_code).to eq(200)
  end

  it 'returns page text' do
    expect(page.text).to include('Texas Embroidery Ranch')
  end
end
