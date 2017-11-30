class Business < ApplicationRecord
  belongs_to :organization
  has_many :emails
  validates :company_name, :email, presence: true

  def primary_contact_name
    "#{first} #{last}".strip
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
end
