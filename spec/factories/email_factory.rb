FactoryBot.define do
  factory :email do
    classification "initial_intro"
    jid SecureRandom.hex(12)

    trait :unscheduled do
      scheduled false
      delivery_date nil 
    end

    trait :scheduled do
      scheduled true
      delivery_date 1.day.from_now 
    end
  end
end
