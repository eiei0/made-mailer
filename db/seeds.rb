require 'faker'

unless User.where(email: "jonathan@madelr.com").present?
  user = User.new(first: "Jonathan", last: "MacDonald", email: "jonathan@madelr.com", password: "Taco123")
  user.skip_confirmation!
  user.save!
end

Business.destroy_all
Email.destroy_all

50.times do |index|
  Business.create!(
    company_name: Faker::Company.name,
    email: Faker::Internet.safe_email("#{Faker::Hipster.words(2).join(" ").parameterize}"),
    first: Faker::Name.first_name,
    last: Faker::Name.last_name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    postal_code: Faker::Address.zip_code,
    country: "United States",
    last_contacted_at: rand(60.days).seconds.ago,
    last_order_placed: rand(60.days).seconds.ago
  )
end
puts "Seeded #{Business.count} Businesses"


200.times do |index|
  id = Business.offset(rand(Business.count)).first.id
  business = Business.find(id)
  Email.create!(
    business_id: id,
    classification: ["followup", "intro"].sample,
    created_at: business.last_contacted_at
  )
end
followups = Email.where(classification: "followup")
intros = Email.where(classification: "intro")
puts "Seeded #{followups.count} followup Emails and #{intros.count} intro Emails"
