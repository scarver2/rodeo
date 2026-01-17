# lib/contact_form.rb
# frozen_string_literal: true

# The contact form
class ContactForm
  attr_accessor :name, :email, :phone, :message
  attr_reader :honeypot

  HONEYPOT_FIELD = 'company'

  def initialize(params)
    @params = params
    @name = params[:name]
    @email = params[:email]
    @phone = params[:phone]
    @message = params[:message]
    @honeypot = params[HONEYPOT_FIELD.to_sym]
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
end
