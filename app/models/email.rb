class Email < ApplicationRecord
  belongs_to :business
  enum classification: {
    initial_intro: 0,
    one_week_intro: 1,
    two_week_intro: 2,
    one_month_followup: 3
  }
end
