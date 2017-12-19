class Notification < ApplicationRecord
  belongs_to :email
  belongs_to :business
end
