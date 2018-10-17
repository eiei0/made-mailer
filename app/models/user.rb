# frozen_string_literal: true

# Used for storing information about the user and authentication
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first, :last, :email, presence: true

  def full_name
    "#{first} #{last}".strip
  end
end
