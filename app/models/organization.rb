class Organization < ApplicationRecord
  has_many :businesses
  has_many :products
  belongs_to :users
end
