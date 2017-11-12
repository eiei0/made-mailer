class Business < ApplicationRecord
  validates :company_name, :email, presence: true

  def primary_contact_name
    "#{first} #{last}".strip
  end
end
