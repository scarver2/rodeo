# frozen_string_literal: true

require_relative '../spec_helper'
# require 'mail'

require_relative '../../lib/contact_form_mailer'

RSpec.describe ContactFormMailer do
  xit 'delivers a multipart email' do
    skip 'TODO: this is just a placeholder'
    ENV['CONTACT_TO'] = 'to@example.com'
    ENV['CONTACT_FROM'] = 'from@example.com'

    Mail.defaults { delivery_method :test }
    Mail::TestMailer.deliveries.clear

    described_class.deliver_contact(
      name: 'Stan',
      email: 'stan@example.com',
      phone: '214-555-1212',
      message: 'Hello',
      request_ip: '127.0.0.1',
      user_agent: 'RSpec'
    )

    expect(Mail::TestMailer.deliveries.size).to eq(1)

    msg = Mail::TestMailer.deliveries.first
    expect(msg.multipart?).to be(true)
    expect(msg.text_part.body.decoded).to include('New contact form submission')
    expect(msg.html_part.body.decoded).to include('<h2>New contact form submission</h2>')
  ensure
    Mail::TestMailer.deliveries.clear
  end
end
