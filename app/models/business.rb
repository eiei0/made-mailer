class Business < ApplicationRecord
  def primary_contact_name
    "#{first} #{last}".strip
  end
end
