class Mailer < ApplicationMailer
  def intro(business, current_user)
    @business_name = business.company_name
    @first_name = business.first
    @last_name = business.last
    @selling_point = business.mailer_selling_point
    @made_wholesale_pw = ENV["wholesale_pw"]
    @sender_contact_phone = current_user.phone || ENV["stacy_phone"]
    @sender_full_name = current_user.full_name || "Stacy MacDonald"
    @sender_job_title = current_user.job_title || "Owner, Designer, Miner & Maker"
    @sender_email = current_user.email || ENV["stacy_email"]

    mail(to: business.email, subject: "Arkansas Quartz Jewelry")
  end

  def followup(business, current_user)
    @business_name = business.company_name
    @first_name = business.first
    @last_name = business.last
    @selling_point = business.mailer_selling_point
    @made_wholesale_pw = ENV["wholesale_pw"]
    @sender_contact_phone = current_user.phone || ENV["stacy_phone"]
    @sender_full_name = current_user.full_name || "Stacy MacDonald"
    @sender_job_title = current_user.job_title || "Owner, Designer, Miner & Maker"
    @sender_email = current_user.email || ENV["stacy_email"]

    mail(to: business.email, subject: "Order Followup")
  end
end
