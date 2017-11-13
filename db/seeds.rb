user = User.new(first: "Jonathan", last: "MacDonald", email: "jonathan@madelr.com", password: "Apptegy123")
user.skip_confirmation!
user.save!

Business.create!(company_name: "The Big Shop", email: "j0nnyappleseed000@mac.com", first: "Chuck E.", last: "Cheese", address: "2101 Sanford Dr.", city: "Little Rock", state: "AR", postal_code: "72227", country: "United States")
