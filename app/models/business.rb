class Business < ApplicationRecord
  has_many :emails

  validates :company_name, :email, presence: true
  validates :email, uniqueness: true

  def primary_contact_name
    "#{first} #{last}".strip
  end

  def scheduled?
    emails.where('delivery_date > ?', DateTime.now).present?
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

  def is_brand_new?
    last_email_delivered.present?
  end

  def last_email_delivered
    emls = self.emails.where(classification: mailer_phase)
    emls.select { |e| e.delivery_date.to_s == last_contacted_at.to_s }
  end
end
