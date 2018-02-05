class Mailer < ApplicationMailer
  default from: 'wholesale@madelr.com'

  def initial_intro(business)
    @business_name = business.company_name
    @contact_first = business.first
    @stacy_email = ENV["stacy_email"]
    @stacy_phone = ENV["stacy_phone"]

    attachments['made_linesheet.pdf'] = File.read('db/data/made_linesheet.pdf')
    mail(to: business.email, subject: 'I mine Quartz from the ground and turn it into jewelry!')
  end

  def first_follow_up(business)
    @business_name = business.company_name
    @contact_first = business.first
    @stacy_email = ENV["stacy_email"]
    @stacy_phone = ENV["stacy_phone"]

    attachments['made_linesheet.pdf'] = File.read('db/data/made_linesheet.pdf')
    mail(to: business.email, subject: 'Touching base about Arkansas Quartz jewelry')
  end

  def second_follow_up(business)
    @business_name = business.company_name
    @contact_first = business.first
    @stacy_email = ENV["stacy_email"]
    @stacy_phone = ENV["stacy_phone"]

    attachments['made_linesheet.pdf'] = File.read('db/data/made_linesheet.pdf')
    mail(to: business.email, subject: 'Hand mined, Handmade Quartz jewelry follow-up')
  end

  def post_purchase_check_in(business)
    @business_name = business.company_name
    @wholesale_email = ENV['wholesale_email']
    @stacy_email = ENV["stacy_email"]
    @stacy_phone = ENV["stacy_phone"]

    mail(to: business.email, subject: "Is it time to restock your made. display?")
  end

  def admin_response_notification(business)
    @business_name = business.company_name

    mail(to: ENV['wholesale_email'], subject: "#{@business_name} response notification")
  end
end
