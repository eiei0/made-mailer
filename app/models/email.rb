class Email < ApplicationRecord
  belongs_to :business

  validates :classification, :scheduled, :deliver_date, presence: true

  enum classification: {
    initial_intro: 0,
    one_week_intro: 1,
    two_week_intro: 2,
    one_month_followup: 3
  }

  def self.schedule!(business, email_params)
    email = self.find_or_create_by!(email_params)
    MailerWorker.perform_in(email.deliver_date, email.id)
  end

  def deliver!
    case classification
    when "initial_intro"
      Mailer.initial_intro(business).deliver!
      update_attribute(:scheduled, false)
    when "one_week_intro"
      Mailer.one_week_intro(business).deliver!
      update_attribute(:scheduled, false)
    when "two_week_intro"
      Mailer.two_week_intro(business).deliver!
      update_attribute(:scheduled, false)
    when "one_month_followup"
      Mailer.one_month_followup(business).deliver!
      update_attribute(:scheduled, false)
    end
  end
end
