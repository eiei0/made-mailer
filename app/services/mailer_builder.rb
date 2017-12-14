class MailerBuilder
  attr_accessor :business, :type, :deliver_now, :delivery_date

  def initialize(business, type, deliver_now, delivery_date=nil)
    @business = business
    @type = type
    @deliver_now = deliver_now
    @delivery_date = delivery_date
  end

  def build!
    email = fetch_or_create_email!
    email.schedule_or_deliver
  end

  private

  def fetch_or_create_email!
    business.emails.create!(email_params)
  end

  def email_params
    {
      classification: type,
      scheduled: (deliver_now.present? ? 1 : 0),
      delivery_date: delivery_date
    }
  end
end
