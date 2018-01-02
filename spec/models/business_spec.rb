require 'rails_helper'

RSpec.describe Business do
  describe '#primary_contact_name' do
    it 'returns a string with the users first and last name included' do
      business = build(:business, first: "Test", last: "User")
      expect(business.primary_contact_name).to eq("Test User")
    end
  end
end
