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
      sms_opt_in: 'on',
      message: 'Hello'
    )

    ContactMailer.new(form).deliver

    expect(Pony).to have_received(:mail).with(hash_including(reply_to: 'john@example.com'))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Name: John Doe')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Email: john@example.com')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Phone: 1234567890')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('SMS Opt-in: Yes')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Message: Hello')))
  end

  it 'includes message and request metadata in the body' do
    request = instance_double(Sinatra::Request, ip: '203.0.113.10', user_agent: 'RSpec UA', referer: 'https://example.com/contact')

    form = ContactForm.new(
      { name: 'Jane Doe', email: 'jane@example.com', phone: '1234567890', message: 'Hello',
        started_at: (Time.now.to_f - 3).to_s },
      request
    )

    described_class.new(form).deliver

    expect(Pony).to have_received(:mail).with(hash_including(body: include('Name: Jane Doe')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Email: jane@example.com')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Phone: 1234567890')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('SMS Opt-in: No')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Message: Hello')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('IP: 203.0.113.10')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('User-Agent: RSpec UA')))
    expect(Pony).to have_received(:mail).with(hash_including(body: include('Referrer: https://example.com/contact')))
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
