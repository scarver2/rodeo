# lib/contact_mailer.rb
# frozen_string_literal: true

require 'pony'

# The contact mailer
class ContactMailer
  def initialize(form)
    @form = form
  end

  def deliver
    Pony.mail(payload)
  end

  private

  def payload
    hsh = {
      from: ENV.fetch('CONTACT_FROM'),
      to: ENV.fetch('CONTACT_TO'),
      reply_to: @form.email,
      subject: subject,
      body: body,
      via: :smtp,
      via_options: smtp_options
    }

    attachment = attachment_payload
    hsh[:attachments] = attachment if attachment

    hsh
  end

  def attachment
    return nil unless @form.respond_to?(:attachment)

    @form.attachment
  end

  def attachment_filename
    return nil unless attachment

    attachment[:filename] || attachment['filename']
  end

  def attachment_tempfile
    return nil unless attachment

    attachment[:tempfile] || attachment['tempfile']
  end

  def read_attachment_tempfile
    tf = attachment_tempfile
    tf.binmode if tf.respond_to?(:binmode)
    tf.rewind if tf.respond_to?(:rewind)
    tf.read
  end

  def attachment_payload
    return nil unless attachment
    return nil if attachment_filename.to_s.strip.blank?
    return nil if attachment_tempfile.nil?

    data = read_attachment_tempfile
    return nil if data.blank?

    { attachment_filename => data }
  end

  def smtp_port
    @smtp_port ||= Integer(ENV.fetch('SMTP_PORT', '587'))
  end

  def smtp_options
    {
      address: ENV.fetch('SMTP_ADDRESS'),
      port: smtp_port,
      domain: ENV.fetch('SMTP_DOMAIN'), # the HELO domain provided by the client to the server
      user_name: ENV.fetch('SMTP_USERNAME'),
      password: ENV.fetch('SMTP_PASSWORD'),
      authentication: (ENV['SMTP_AUTH'] || 'login').to_sym, # :plain, :login, :cram_md5, no auth by default

      # If port is 465, implicit TLS is usually correct.
      ssl: env_bool('SMTP_SSL', default: smtp_port == 465),

      # If port is 587, STARTTLS is usually correct.
      enable_starttls_auto: env_bool('SMTP_STARTTLS', default: smtp_port != 465),

      # optional but helpful
      open_timeout: Integer(ENV.fetch('SMTP_OPEN_TIMEOUT', '10')),
      read_timeout: Integer(ENV.fetch('SMTP_READ_TIMEOUT', '20'))
    }.compact
  end

  def env_bool(key, default:)
    val = ENV.fetch(key, nil)
    return default if val.nil?

    val.strip.downcase == 'true'
  end

  def body
    <<~BODY
      Name: #{safe_form_value(:name)}
      Email: #{safe_form_value(:email)}
      Phone: #{safe_form_value(:phone)}
      SMS Opt-in: #{sms_consent_line}
      Message: #{safe_form_value(:message)}

      ---
      IP: #{safe_form_value(:ip)}
      User-Agent: #{safe_form_value(:user_agent)}
      Referrer: #{safe_form_value(:referer)}
    BODY
  end

  def safe_form_value(method_name)
    return '(unknown)' unless @form.respond_to?(method_name)

    val = @form.public_send(method_name)
    val.to_s.strip.empty? ? '(unknown)' : val.to_s
  end

  def sms_consent_line
    @form.sms_opted_in? ? 'Yes' : 'No'
  end

  def subject
    ENV.fetch('CONTACT_SUBJECT', 'Contact Form')
  end
end
