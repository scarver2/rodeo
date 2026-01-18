# lib/contact_form.rb
# frozen_string_literal: true

# The contact form
class ContactForm
  attr_accessor :name, :email, :phone, :message, :sms_opt_in
  attr_reader :attachment, :honeypot, :ip, :user_agent, :referer

  HONEYPOT_FIELD = 'company'
  MIN_FORM_SECONDS = 2.0

  def initialize(params, request = nil)
    @params = params

    # Support both symbol and string keys (Rack params are often strings)
    @name    = fetch(:name)
    @email   = fetch(:email)
    @phone   = fetch(:phone)
    @message = fetch(:message)

    # Spam detection fields
    @honeypot = fetch(HONEYPOT_FIELD)
    @started_at = fetch(:started_at)

    # SMS/marketing consent checkbox.
    # HTML checkboxes post "on" when checked and nothing when unchecked.
    @sms_opt_in = truthy?(fetch(:sms_opt_in, false))

    # Single attachment payload:
    # { filename: "artwork.png", tempfile: <Tempfile> }
    @attachment = normalize_attachment(fetch(:attachment))

    # Request metadata
    @ip = request&.ip
    @user_agent = request&.user_agent
    @referer = request&.referer
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

  def sms_opted_in?
    @sms_opt_in
  end

  # TODO: move truthy? to utility class
  def truthy?(value)
    %w[1 ON T TRUE].include?(value.to_s.strip.upcase)
  end

  def valid?
    name.present? && email.present? && phone.present? && !spam?
  end

  def started_at
    @started_at || Time.now.to_f
  end

  private

  def too_fast?
    started = started_at_seconds
    return false if started.nil? # allow missing/invalid started_at

    elapsed = Time.now.to_f - started
    elapsed < MIN_FORM_SECONDS
  end

  def started_at_seconds
    return nil if @started_at.blank?

    # Expecting epoch float/string, e.g. "1737154312.123", fail if not
    Float(@started_at)
    # rescue ArgumentError, TypeError
    #   nil
  end

  # TODO: move fetch to utility class
  def fetch(key, default = nil)
    return default if @params.nil?

    # Allow callers to pass String keys directly (like 'company')
    if key.is_a?(String)
      @params[key] || @params[key.to_sym] || default
    else
      @params[key] || @params[key.to_s] || default
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
