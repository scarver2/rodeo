# frozen_string_literal: true

require 'mail'

class ContactFormMailer
  attr_reader :name, :email, :phone, :message, :request_ip, :user_agent

  def self.deliver(name:, email:, phone:, message:, request_ip:, user_agent:)
    @name = name
    @email = email
    @phone = phone
    @message = message
    @request_ip = request_ip
    @user_agent = user_agent

    @from = ENV.fetch('CONTACT_FROM', nil)
    @to = ENV.fetch('CONTACT_TO', nil)
    @subject = 'New contact form submission'
    # TODO: Add HTML body from view template
    # @html_body = erb :contact_form_mailer
    # @html_body = erb :contact_form_mailer_html
    # TODO: Add Text body from view template
    @text_body = "Name: #{name}\nEmail: #{email}\nPhone: #{phone}\nMessage: #{message}\nRequest IP: #{request_ip}\nUser Agent: #{user_agent}"
    # @text_body = erb :contact_form_mailer_text

    # TODO: Add SMTP settings
    Mail.defaults do
      delivery_method :smtp, {
        address: ENV.fetch('SMTP_HOST', nil),
        port: ENV.fetch('SMTP_PORT', nil),
        user_name: ENV.fetch('SMTP_USER', nil),
        password: ENV.fetch('SMTP_PASSWORD', nil),
        authentication: 'plain',
        enable_starttls_auto: true
      }
    end

    Mail.deliver do
      from @from
      to @to
      subject @subject
      body @body
    end
  end
end

# mail.defaults do
#   delivery_method :smtp, {
#     address: ENV.fetch('SMTP_HOST', nil),
#     port: ENV.fetch('SMTP_PORT', nil),
#     user_name: ENV.fetch('SMTP_USER', nil),
#     password: ENV.fetch('SMTP_PASSWORD', nil),
#     authentication: 'plain',
#     enable_starttls_auto: true
#   }
# end
