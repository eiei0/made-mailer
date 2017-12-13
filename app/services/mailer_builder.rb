class MailerBuilder
  attr_accessor :business, :type, :email

  def initialize(business, type, email=nil)
    @business = business
    @type = type
    @email = email
  end

  def build
    case type
    when "initial_intro"
      Email.schedule!(business, {
        classification: 0,
        scheduled: true,
        business_id: business.id,
        deliver_date: (email.present? ? email.deliver_date : DateTime.now.end_of_day)
      })
    when "one_week_intro"
      last_email = business.emails.where(classification: 0).last
      Email.schedule!(business, {
        classification: 1,
        scheduled: true,
        business_id: business.id,
        deliver_date: (email.present? ? email.deliver_date : last_email.deliver_date + 7.days)
      })
    when "two_week_intro"
      last_email = business.emails.where(classification: 1).last
      Email.schedule!(business, {
        classification: 2,
        scheduled: true,
        business_id: business.id,
        deliver_date: (email.present? ? email.deliver_date : last_email.deliver_date + 14.days)
      })
    when "one_month_followup"
      Email.schedule!(business, {
        classification: 3,
        scheduled: true,
        business_id: business.id,
        deliver_date: (email.present? ? email.deliver_date : business.last_order_placed + 30.days)
      })
    end
  end
end
