# frozen_string_literal: true

# Stores product information
class Product < ApplicationRecord
  monetize :price_cents
end
