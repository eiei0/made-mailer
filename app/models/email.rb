class Email < ApplicationRecord
  belongs_to :business
  has_many :notifications

  validates :classification, presence: true

  scope :scheduled, -> { where('delivery_date > ?', DateTime.now) }

  enum classification: {
    initial_intro: 0,
    one_week_intro: 1,
    two_week_intro: 2,
    one_month_followup: 3,
    inbound: 4
  }

  def schedule_mailer
    jid = MailerWorker.perform_in(delivery_date, id)
    update_attribute(:jid, jid)
  end

  def deliver!
    # consider switching this to MailerWorker.perform_async(classification.to_sym, id)
    mailer = Mailer.public_send(classification.to_sym, business)
    update_records if mailer.deliver!
  end

  def schedule_or_deliver
    if scheduled?
      schedule_mailer
    else
      deliver!
    end
  end

  def self.mailers_delivered(start_date)
    where(scheduled: false).where('delivery_date > ?', start_date)
  end

  def self.notify_admin(business)
    Mailer.admin_response_notification(business).deliver!
  end

  private

  def update_records
    update_attributes(scheduled: false, delivery_date: DateTime.now)
    business.update_after_mailer_delivery(classification)
  end
end
