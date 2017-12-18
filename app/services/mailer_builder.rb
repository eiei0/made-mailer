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
      schedule_recurring_mailers(email) if business.is_new?
    end
  end

  private

  def create_email!
    business.emails.create!(email_params)
  end

  def email_params
    {
      classification: type,
      scheduled: (deliver_now == "1" ? 0 : 1),
      delivery_date: delivery_date
    }
  end

  def schedule_recurring_mailers(email)
    scheduled_delivery_dates(email).each do |phase|
      email = business.emails.create!(
        classification: phase[0],
        delivery_date: phase[1],
        scheduled: true
      )
      email.schedule_mailer
    end
  end

  def scheduled_delivery_dates(email)
    {
      one_week_intro: email.delivery_date + 1.weeks,
      two_week_intro: email.delivery_date + 2.weeks
    }
  end
end
