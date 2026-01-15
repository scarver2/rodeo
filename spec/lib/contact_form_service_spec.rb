# # frozen_string_literal: true

# require_relative '../spec_helper'
# require 'mail'

# require_relative '../../app/services/contact_form_service'

# RSpec.describe ContactFormService do
#   it 'delivers a multipart email' do
#     ENV['CONTACT_TO'] = 'to@example.com'
#     ENV['CONTACT_FROM'] = 'from@example.com'

#     Mail.defaults { delivery_method :test }
#     Mail::TestMailer.deliveries.clear

#     described_class.deliver_contact(
#       name: 'Stan',
#       email: 'stan@example.com',
#       phone: '214-555-1212',
#       message: 'Hello',
#       request_ip: '127.0.0.1',
#       user_agent: 'RSpec'
#     )

#     expect(Mail::TestMailer.deliveries.size).to eq(1)

#     msg = Mail::TestMailer.deliveries.first
#     expect(msg.multipart?).to be(true)
#     expect(msg.text_part.body.decoded).to include('New contact form submission')
#     expect(msg.html_part.body.decoded).to include('<h2>New contact form submission</h2>')
#   ensure
#     Mail::TestMailer.deliveries.clear
#   end

#   it "raises if required env vars are missing" do
#     ENV.delete('CONTACT_TO')
#     ENV.delete('CONTACT_FROM')

#     expect do
#       described_class.deliver_contact(
#         name: 'Stan', email: 'stan@example.com', phone: '', message: 'Hello'
#       )
#     end.to raise_error(ArgumentError, /Missing ENV\['CONTACT_TO'\]/)
#   end
# end

# frozen_string_literal: true

require_relative '../spec_helper'
# require 'mail'

require_relative '../../lib/contact_form_service'

RSpec.describe ContactFormService do
  context 'invalid form' do
    it 'missing fields' do
      params = {}
      service = ContactFormService.new(params)
      expect(service.call).to be_falsey
      expect(service.errors).to include('Email is required')
    end

    it 'invalid email' do
      params = { email: 'username[at]example.com' }
      service = ContactFormService.new(params)
      expect(service.call).to be_falsey
      expect(service.errors).to include('Email is invalid')
    end

    it 'spam' do
      params = { pooh_bear: '1' }
      service = ContactFormService.new(params)
      expect(service.call).to be_falsey
    end
  end

  context 'valid form' do
    it 'send email' do
      allow(ContactFormMailer).to receive(:deliver).and_return(true)
      params = {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.phone_number,
        message: Faker::Lorem.sentence,
        request_ip: Faker::Internet.ip_v4_address
        # user_agent: Faker::UserAgent.user_agent
      }
      service = ContactFormService.new(params)
      expect(service.call).to be_truthy
    end
  end
end

# RSpec.describe ContactFormService do
#   it 'validates the form' do
#     service = ContactFormService.new({})
#     expect(service.call).to be_falsey
#     expect(service.errors).to include('Email is required')
#   end
# end
