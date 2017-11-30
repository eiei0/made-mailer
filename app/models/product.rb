class Product < ApplicationRecord
  belongs_to :organization
  monetize :price_cents
end
