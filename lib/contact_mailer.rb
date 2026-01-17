# lib/contact_mailer.rb
# frozen_string_literal: true

require 'pony'

# The contact mailer
class ContactMailer
  def initialize(form)
    @form = form
  end

  def deliver
    Pony.mail(
      from: ENV.fetch('CONTACT_FROM'),
      to: ENV.fetch('CONTACT_TO'),
      reply_to: @form.email,
      subject: subject,
      body: body,
      via: :smtp,
      via_options: smtp_options
    )
  end

  private

  def smtp_options
    {
      address: ENV.fetch('SMTP_ADDRESS'),
      port: Integer(ENV.fetch('SMTP_PORT', 587)),
      domain: ENV.fetch('SMTP_DOMAIN'), # the HELO domain provided by the client to the server
      user_name: ENV.fetch('SMTP_USERNAME'),
      password: ENV.fetch('SMTP_PASSWORD'),
      authentication: (ENV['SMTP_AUTH'] || 'login').to_sym, # :plain, :login, :cram_md5, no auth by default

      # ✅ implicit TLS on 465
      ssl: env_bool('SMTP_SSL', default: true),

      # ❌ don't do STARTTLS on 465
      enable_starttls_auto: env_bool('SMTP_STARTTLS', default: false),

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
      Name: #{@form.name}
      Email: #{@form.email}
      Phone: #{@form.phone}
      Message: #{@form.message}
    BODY
  end

  def subject
    ENV.fetch('CONTACT_SUBJECT', 'Contact Form')
  end
end
