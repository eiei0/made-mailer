class Email < ApplicationRecord
  belongs_to :business
  enum classification: { intro: 0, followup: 1 }
end
