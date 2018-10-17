# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    company_name "Test Business"
    email "test@test.com"
    first "Test"
    last "User"
    url "https://www.test.com/"

    factory :business_with_scheduled_emails do
      transient do
        emails_count 5
      end

      after(:create) do |business, evaluator|
        create_list(:email, evaluator.emails_count, :scheduled, business: business)
      end
    end

    factory :business_with_unscheduled_emails do
      transient do
        emails_count 5
      end

      after(:create) do |business, evaluator|
        create_list(:email, evaluator.emails_count, :unscheduled, business: business)
      end
    end
  end
end
