# lib/contact_form.rb
# frozen_string_literal: true

# The contact form
class ContactForm
  attr_accessor :name, :email, :phone, :message
  attr_reader :attachment, :honeypot

  HONEYPOT_FIELD = 'company'

  def initialize(params)
    @params = params

    # Support both symbol and string keys (Rack params are often strings)
    @name    = fetch(:name)
    @email   = fetch(:email)
    @phone   = fetch(:phone)
    @message = fetch(:message)
    @honeypot = fetch(HONEYPOT_FIELD)

    # Single attachment payload:
    # { filename: "artwork.png", tempfile: <Tempfile> }
    @attachment = normalize_attachment(fetch(:attachment))
  end

  def errors
    @errors = []
    if @params.present?
      @errors << 'Error occurred' if honeypot.present?
      @errors << 'Name is required' if name.blank?
      @errors << 'Email is required' if email.blank?
      @errors << 'Phone is required' if phone.blank?
      @errors << 'Message is required' if message.blank?
    end
    @errors
  end

  def spam?
    honeypot.present?
  end

  def valid?
    name.present? && email.present? && phone.present? && !spam?
  end

  private

  def fetch(key)
    return nil if @params.nil?

    # Allow callers to pass String keys directly (like 'company')
    if key.is_a?(String)
      @params[key] || @params[key.to_sym]
    else
      @params[key] || @params[key.to_s]
    end
  end

  def normalize_attachment(value)
    return nil if value.nil?

    filename = value[:filename] || value['filename']
    tempfile = value[:tempfile] || value['tempfile']

    return nil if filename.to_s.strip.empty?
    return nil if tempfile.nil?

    { filename: filename, tempfile: tempfile }
  end
end
