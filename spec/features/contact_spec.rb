# spec/features/contact_spec.rb
# frozen_string_literal: true

require_relative '../rack_helper'

RSpec.describe 'Contact form', type: :feature do
  it 'submits the form and shows Thank You' do
    name = Faker::Name.name
    email = Faker::Internet.email
    phone = Faker::PhoneNumber.phone_number
    message = Faker::Lorem.sentence

    visit '/contact'

    fill_in 'name', with: name
    fill_in 'email', with: email
    fill_in 'phone', with: phone
    fill_in 'message', with: message

    click_button 'Send'

    expect(page).to have_current_path('/contact/thank_you')
    expect(page).to have_content('Thank You')

    expect(Pony).to have_received(:mail).with(
      hash_including(
        from: include('John Doe'),
        to: include('Jane Doe'),
        reply_to: email,
        subject: include('Howdy'),
        body: include(message)
      )
    )
  end

  it 'submits the invalid form and shows error' do
    visit '/contact'

    fill_in 'name', with: ''
    fill_in 'email', with: ''
    fill_in 'phone', with: ''
    fill_in 'message', with: Faker::Lorem.sentence

    click_button 'Send'

    expect(page).to have_current_path('/contact/new')
    expect(page).to have_content('Name is required')
    expect(page).to have_content('Email is required')
    expect(page).to have_content('Phone is required')
  end
end
