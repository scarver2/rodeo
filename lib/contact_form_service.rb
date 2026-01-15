# frozen_string_literal: true

require 'active_support/all'

# Service object for handling contact form submissions
class ContactFormService
  HONEYPOT_FIELD = 'pooh_bear'

  attr_accessor :name, :email, :phone, :message, :request_ip, :user_agent

  def initialize(params)
    @params = params
    @name = params.try(:[], :name)
    @email = params.try(:[], :email)
    @phone = params.try(:[], :phone)
    @message = params.try(:[], :message)
    @request_ip = params.try(:[], :request_ip)
    @user_agent = params.try(:[], :user_agent)
  end

  def call
    return false if spam?
    return false unless valid?

    send_email
  end

  attr_reader :errors

  private

  def spam?
    @params[HONEYPOT_FIELD].present?
  end

  def valid?
    @errors = []
    @errors << 'Name is required' if name.blank?
    @errors << 'Phone is required' if phone.blank?
    @errors << 'Email is required' if email.blank?
    @errors << 'Email is invalid' if email.present? && !valid_email_format?(email)
    @errors.empty?
  end

  def valid_email_format?(email)
    # Use a regex or a library to validate email format
    email =~ /\A[^@\s]+@[^@\s]+\z/
  end

  def send_email
    # Use ActionMailer to send the email
    # TODO: UserMailer.welcome_email(self).deliver_now
    # TODO: send mail
    ContactFormMailer.deliver(name: name, email: email, phone: phone, message: message, request_ip: request_ip,
                              user_agent: user_agent)
  end
end
