# frozen_string_literal: true

# Handles the scheduling and delivery of emails
class MailerBuilder
  attr_accessor :business, :type, :deliver_now, :delivery_date

  def initialize(business, type, deliver_now, delivery_date=nil)
    @business = business
    @type = type
    @deliver_now = deliver_now
    @delivery_date = delivery_date
  end

  def build!
    ActiveRecord::Base.transaction do
      email = create_email!
      email.schedule_or_deliver
      email.schedule_recurring_mailers if business.new?
    end
  end

  private

  def create_email!
    business.emails.create!(email_params)
  end

  def email_params
    {
      classification: type,
      scheduled: deliver_now.to_i,
      delivery_date: delivery_date
    }
  end
end
