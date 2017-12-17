class Email < ApplicationRecord
  belongs_to :business

  validates :classification, presence: true
  validates :delivery_date, presence: true, if: :scheduled_attr_true?

  enum classification: {
    initial_intro: 0,
    one_week_intro: 1,
    two_week_intro: 2,
    one_month_followup: 3
  }

  def schedule!
    jid = MailerWorker.perform_in(delivery_date, id)
    update_attribute(:jid, jid)
  end

  def scheduled?
    return false if delivery_date.blank?
    delivery_date > DateTime.now
  end

  def deliver!
    # consider switching this to MailerWorker.perform_async(classification.to_sym, id)
    mailer = Mailer.public_send(classification.to_sym, business)
    update_records if mailer.deliver!
  end

  def schedule_or_deliver
    if scheduled?
      schedule!
    else
      deliver!
    end
  end

  def self.mailers_delivered(start_date)
    where(scheduled: false).where('delivery_date > ?', start_date)
  end

  private

  def update_records
    update_attributes(scheduled: false, delivery_date: DateTime.now)
    business.update_after_mailer_delivery(classification)
  end

  def scheduled_attr_true?
    scheduled == true
  end
end
