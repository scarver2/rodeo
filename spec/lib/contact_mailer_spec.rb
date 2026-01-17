# spec/lib/contact_mailer_spec.rb
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/contact_mailer'

RSpec.describe ContactMailer do
  it 'sends an email' do
    form = ContactForm.new(
      name: 'John Doe',
      email: 'john@example.com',
      phone: '1234567890',
      message: 'Hello'
    )

    ContactMailer.new(form).deliver

    expect(Pony).to have_received(:mail).with(
      hash_including(
        reply_to: 'john@example.com',
        body: include("Name: John Doe\nEmail: john@example.com\nPhone: 1234567890\nMessage: Hello")
      )
    )
  end
end
