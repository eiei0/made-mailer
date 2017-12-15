class Email < ApplicationRecord
  belongs_to :business

  validates :classification, :scheduled, presence: true
  # TODO: Should validate presence of :delivery_date when :scheduled is true

  enum classification: {
    initial_intro: 0,
    one_week_intro: 1,
    two_week_intro: 2,
    one_month_followup: 3
  }

  def schedule!
    MailerWorker.perform_in(delivery_date, id)
  end

  def scheduled?
    return false if delivery_date.blank?
    delivery_date > DateTime.now
  end

  def deliver!
    mailer = Mailer.try(classification.to_sym, business)
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
    business.update_attribute(:last_contacted_at, DateTime.now)
  end
end
