# lib/contact_mailer.rb
# frozen_string_literal: true

require 'pony'

# The contact mailer
class ContactMailer
  TEMPLATE_DIR = File.expand_path('../views/mailers', __dir__)
  HTML_TEMPLATE = 'contact.html.erb'
  TEXT_TEMPLATE = 'contact.text.erb'

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
      body: text_body,
      html_body: html_body,
      via: :smtp,
      via_options: smtp_options
    }

    attachment = attachment_payload
    hsh[:attachments] = attachment if attachment

    hsh
  end

  # Fetch the attachment hash from the form (if the form supports attachments).
  def attachment
    return nil unless @form.respond_to?(:attachment)

    @form.attachment
  end

  # Extract the attachment filename from the normalized attachment hash.
  def attachment_filename
    return nil unless attachment

    attachment[:filename] || attachment['filename']
  end

  # Extract the attachment tempfile (IO-like object) from the normalized attachment hash.
  def attachment_tempfile
    return nil unless attachment

    attachment[:tempfile] || attachment['tempfile']
  end

  # Read the attachment tempfile from the beginning, in binary mode when supported.
  def read_attachment_tempfile
    tf = attachment_tempfile
    tf.binmode if tf.respond_to?(:binmode)
    tf.rewind if tf.respond_to?(:rewind)
    tf.read
  end

  # Build Pony-compatible attachments payload { "filename.ext" => <bytes> }, or nil if missing/empty.
  def attachment_payload
    return nil unless attachment_present?

    data = read_attachment_tempfile
    return nil if data.blank?

    { attachment_filename => data }
  end

  def attachment_present?
    attachment_filename.present? && attachment_tempfile.present?
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

  def html_body
    render_template(template_path(HTML_TEMPLATE), assigns)
  end

  def text_body
    render_template(template_path(TEXT_TEMPLATE), assigns)
  end

  def template_path(filename_or_path)
    # Allow passing a full path, otherwise resolve within template_dir
    if filename_or_path.to_s.include?(File::SEPARATOR)
      File.expand_path(filename_or_path.to_s)
    else
      File.expand_path(filename_or_path.to_s, TEMPLATE_DIR)
    end
  end

  def assigns
    {
      name: safe_form_value(:name),
      email: safe_form_value(:email),
      phone: safe_form_value(:phone),
      message: safe_form_value(:message),
      request_ip: safe_form_value(:ip),
      user_agent: safe_form_value(:user_agent),
      referer: safe_form_value(:referer),
      sms_opt_in: sms_consent_line
    }
  end

  def render_template(path, assigns_hash)
    TemplateRenderer.new(path, assigns_hash).render
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

  # Renders ERB templates with instance variables (e.g. @name, @email, etc).
  class TemplateRenderer
    def initialize(template_path, assigns = {})
      @template_path = template_path
      assigns.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def render
      template = File.read(@template_path)
      ERB.new(template).result(binding)
    end
  end
end
