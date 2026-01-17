# spec/lib/contact_form_spec.rb
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/contact_form'

RSpec.describe ContactForm do
  it 'validates a valid form' do
    form = ContactForm.new(
      name: 'John Doe',
      email: 'john@example.com',
      phone: '1234567890',
      message: 'Hello'
    )

    expect(form.valid?).to be_truthy
    expect(form.errors).to be_empty
  end

  it 'validates an invalid form' do
    form = ContactForm.new(
      name: '',
      email: '',
      phone: '',
      message: ''
    )

    expect(form.valid?).to be_falsey
    expect(form.errors).to include('Name is required')
    expect(form.errors).to include('Email is required')
    expect(form.errors).to include('Phone is required')
    expect(form.errors).to include('Message is required')
  end

  it 'detects spam' do
    form = ContactForm.new(
      name: 'John Doe',
      email: 'john@example.com',
      phone: '1234567890',
      message: 'Hello',
      company: 'Spam'
    )

    expect(form.spam?).to be_truthy
  end

  it 'accepts a single attachment (uploaded file payload)' do
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

    expect(form).to respond_to(:attachment)
    expect(form.attachment).not_to be_nil
  ensure
    tempfile.close!
  end
end
