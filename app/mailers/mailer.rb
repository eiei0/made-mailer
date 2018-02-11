# Handles the delivery of mailers
class Mailer < ApplicationMailer
  default from: 'wholesale@madelr.com'
  before_action :add_all_attachments,
                only: %i[initial_intro first_follow_up second_follow_up]
  before_action :attach_linesheet, only: :post_purchase_check_in

  def initial_intro(business)
    @business = business
    @stacy_email = ENV['stacy_email']
    @stacy_phone = ENV['stacy_phone']

    mail(to: business.email,
         subject: 'I mine Quartz from the ground and turn it into jewelry!')
  end

  def first_follow_up(business)
    @business = business
    @stacy_email = ENV['stacy_email']
    @stacy_phone = ENV['stacy_phone']
    @intial_intro_body = business.emails.select do |e|
      e.classification == 'initial_intro'
    end.first.body.html_safe

    mail(to: business.email,
         subject: 'Touching base about Arkansas Quartz jewelry')
  end

  def second_follow_up(business)
    @business = business
    @stacy_email = ENV['stacy_email']
    @stacy_phone = ENV['stacy_phone']
    @first_followup_body = business.emails.select do |e|
      e.classification == 'first_follow_up'
    end.first.body.html_safe

    mail(to: business.email,
         subject: 'Hand mined, Handmade Quartz jewelry follow-up')
  end

  def post_purchase_check_in(business)
    @business_name = business.company_name
    @wholesale_email = ENV['wholesale_email']
    @stacy_email = ENV['stacy_email']
    @stacy_phone = ENV['stacy_phone']

    mail(to: business.email,
         subject: 'Is it time to restock your made. display?')
  end

  def admin_response_notification(business)
    @business_name = business.company_name

    mail(to: ENV['wholesale_email'],
         subject: "#{@business_name} response notification")
  end

  private

  def add_all_attachments
    attachments['made_linesheet.pdf'] = File.read('db/data/made_linesheet.pdf')
    attachments['1.jpg'] = File.read('db/data/1.jpg')
    attachments['2.jpg'] = File.read('db/data/2.jpg')
    attachments['3.jpg'] = File.read('db/data/3.jpg')
    attachments['4.jpg'] = File.read('db/data/4.jpg')
    attachments['5.jpg'] = File.read('db/data/5.jpg')
  end

  def attach_linesheet
    attachments['made_linesheet.pdf'] = File.read('db/data/made_linesheet.pdf')
  end
end
