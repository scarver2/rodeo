# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'Contact form', type: :feature do
  it 'submits the form and shows Thank You' do
    visit '/contact'

    # These must match your form input names/labels
    fill_in 'name', with: Faker::Name.name
    fill_in 'email', with: Faker::Internet.email
    fill_in 'message', with: Faker::Lorem.sentence

    # This must match your submit button text/value
    click_button 'Send'

    expect(page).to have_current_path('/contact/thank_you')
    expect(page).to have_content('Thank You')
  end

  it 'submits the invalid form and shows error' do
    skip 'TODO: implement after ContactFormService is implemented'
    visit '/contact'

    # These must match your form input names/labels
    fill_in 'name', with: Faker::Name.name
    fill_in 'email', with: ''
    fill_in 'message', with: Faker::Lorem.sentence

    # This must match your submit button text/value
    click_button 'Send'

    expect(page).to have_current_path('/contact')
    expect(page).to have_content('Error')
  end
end
