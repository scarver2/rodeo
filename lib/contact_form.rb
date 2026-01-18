# lib/contact_form.rb
# frozen_string_literal: true

# The contact form
class ContactForm
  attr_accessor :name, :email, :phone, :message
  attr_reader :attachment, :honeypot

  HONEYPOT_FIELD = 'company'
  MIN_FORM_SECONDS = 2.0

  def initialize(params)
    @params = params

    # Support both symbol and string keys (Rack params are often strings)
    @name    = fetch(:name)
    @email   = fetch(:email)
    @phone   = fetch(:phone)
    @message = fetch(:message)

    # Spam detection fields
    @honeypot = fetch(HONEYPOT_FIELD)
    @started_at = fetch(:started_at)

    # Single attachment payload:
    # { filename: "artwork.png", tempfile: <Tempfile> }
    @attachment = normalize_attachment(fetch(:attachment))
  end

  def errors
    @errors = []
    if @params.present?
      @errors << 'Error occurred' if spam?
      @errors << 'Name is required' if name.blank?
      @errors << 'Email is required' if email.blank?
      @errors << 'Phone is required' if phone.blank?
      @errors << 'Message is required' if message.blank?
    end
    @errors
  end

  def spam?
    honeypot.present? || too_fast?
  end

  def valid?
    name.present? && email.present? && phone.present? && !spam?
  end

  def started_at
    @started_at || Time.now.to_f
  end

  private

  def too_fast?
    return false if @started_at.blank?

    elapsed = Time.now.to_f - @started_at.to_f
    elapsed < MIN_FORM_SECONDS
  end

  def started_at_seconds
    return nil if started_at.nil?

    # Expecting epoch float/string, e.g. "1737154312.123"
    Float(started_at)
  rescue ArgumentError, TypeError
    nil
  end

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
