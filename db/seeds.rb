require 'faker'

unless User.where(email: "jonathan@madelr.com").present?
  user = User.new(first: "Jonathan", last: "MacDonald", email: "jonathan@madelr.com", password: "Taco123")
  user.skip_confirmation!
  user.save!
end

Business.destroy_all
Email.destroy_all
Product.destroy_all

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
    classification: [3, 0].sample,
    scheduled: true,
    delivery_date: rand(30).days.from_now,
    created_at: business.last_contacted_at
  )
end
followups = Email.where(classification: 3)
intros = Email.where(classification: 0)
puts "Seeded #{followups.count} followup Emails and #{intros.count} intro Emails"

products = [{ name: "Signature 26” Necklace - Gold", price: 9.59 },
            { name: "Signature 26” Necklace - Rose Gold", price: 11.85 },
            { name: "Signature 26” Necklace - Sterling", price: 6.81 },
            { name: "Classic 16” Necklace - Gold", price: 6.03 },
            { name: "Classic 16” Necklace - Rose Gold", price: 7.73 },
            { name: "Classic 16” Necklace - Sterling", price: 4.65 },
            { name: "Lariat - Gold Filled", price: 10.54 },
            { name: "Lariat - Mixed Metal w/ Sterling", price: 8.33 },
            { name: "Cluster Necklace", price: 5.99 },
            { name: "Cord & Chain Necklace", price: 11.45 },
            { name: "Bracelet - Gold", price: 5.69 },
            { name: "Bracelet - Rose Gold", price: 7.22 },
            { name: "Bracelet - Sterling", price: 4.43 },
            { name: "Threads - Sterling", price: 4.78},
            { name: "Studs - Brass", price: 3.77 },
            { name: "Dangles - Gold Plated Brass", price: 3.92 },
            { name: "Dangles - Silver Plated Brass", price: 3.88 },
            { name: "Echo Earrings - Large Gold Plated Brass", price: 1.94 },
            { name: "Echo Earrings - Large Silver Plated Brass", price: 1.94 },
            { name: "Echo Earrings - Small Gold Plated Brass", price: 1.94 },
            { name: "Echo Earrings - Small Silver Plated Brass", price: 1.94 }]
Product.create!(products)
puts "Seeded #{products.count} products"
