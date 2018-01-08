class Business < ApplicationRecord
  has_many :emails
  has_many :notifications

  validates :company_name, :email, presence: true
  validates :email, uniqueness: true

  before_save :downcase_email

  enum status: {
    pending: 0,
    current_wholesale_vendor: 1,
    current_consignment_vendor: 2,
    declined: 3,
    followup_later: 4,
    response_received: 5
  }

  before_validation :smart_add_url_protocol

  def primary_contact_name
    "#{first} #{last}".strip
  end

  def scheduled?
    emails.scheduled.present?
  end

  def responded?
    status == "response_received"
  end

  def self.search(search)
    if search
      where(
        'first ILIKE ? OR last ILIKE ? OR company_name ILIKE ? OR email ILIKE ?',
        "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"
      )
    else
      all
    end
  end

  def update_after_mailer_delivery(mailer_phase)
    update_attributes(last_contacted_at: DateTime.now, mailer_phase: mailer_phase)
  end

  def is_new?
    mailer_phase == "initial_intro"
  end

  def destroy_all_mailers
    cancel_mailers(emails.map(&:jid))
    emails.destroy_all
  end

  def stop_email_flow
    cancel_mailers(emails.map(&:jid))
    emails.where(scheduled: true).destroy_all
  end

  private

  def cancel_mailers(jids)
    jids.each do |jid|
      MailerWorker.cancel!(jid)
    end
  end

  def smart_add_url_protocol
    unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
      self.url = "http://#{self.url}"
    end
  end

  def downcase_email
    self.email.downcase!
  end
end
