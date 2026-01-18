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

  it 'includes message and request metadata in the body' do
    request = instance_double(Sinatra::Request, ip: '203.0.113.10', user_agent: 'RSpec UA', referer: 'https://example.com/contact')

    form = ContactForm.new(
      { name: 'John Doe', email: 'john@example.com', phone: '1234567890', message: 'Hello',
        started_at: (Time.now.to_f - 3).to_s },
      request
    )

    described_class.new(form).deliver

    expect(Pony).to have_received(:mail).with(
      hash_including(
        body: include(
          'Message: Hello',
          'IP: 203.0.113.10',
          'User-Agent: RSpec UA',
          'Referrer: https://example.com/contact'
        )
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
