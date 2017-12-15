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

  def update_contacted_date
    update_attribute(:last_contacted_at, DateTime.now)
  end
end
