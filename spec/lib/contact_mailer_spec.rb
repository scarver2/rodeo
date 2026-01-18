# spec/lib/contact_mailer_spec.rb
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/contact_form'
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

  it 'sends an email with a single attachment' do
    allow(Pony).to receive(:mail)

    tempfile = Tempfile.new(['artwork', '.png'])
    tempfile.binmode
    tempfile.write('PNGDATA')
    tempfile.rewind

    form = ContactForm.new(
      name: 'John Doe',
      email: 'john@example.com',
      phone: '1234567890',
      message: 'Hello',
      attachment: {
        filename: 'artwork.png',
        tempfile: tempfile
      }
    )

    ContactMailer.new(form).deliver

    expect(Pony).to have_received(:mail).with(
      hash_including(
        reply_to: 'john@example.com',
        attachments: {
          'artwork.png' => 'PNGDATA'
        }
      )
    )
  ensure
    tempfile.close!
  end
end
