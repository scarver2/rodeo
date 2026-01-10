# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'Homepage', type: :feature do
  before do
    visit '/'
  end

  it 'loads successfully' do
    expect(page.status_code).to eq(200)
    expect(page.text).to match(/Howdy/i)
  end
end
