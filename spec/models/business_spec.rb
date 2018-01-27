require 'rails_helper'

RSpec.describe Business do
  describe '#primary_contact_name' do
    it 'returns a string with the users first and last name included' do
      business = build(:business, first: "Test", last: "User")
      expect(business.primary_contact_name).to eq("Test User")
    end
  end

  describe '#scheduled?' do
    context 'when business has an assocated email that has a delivery date in the future' do
      it 'returns true' do
        business = create(:business_with_scheduled_emails)
        expect(business.scheduled?).to be true
      end
    end

    context 'when business does not have an associated email that has a delivery date in the future' do
      it 'returns false' do
        business = create(:business_with_unscheduled_emails)
        expect(business.scheduled?).to be false
      end
    end
  end

  describe '#responded?' do
    it '' do
      business = build(:business, status: "response_received")
      expect(business.responded?).to be true
    end
  end

  describe '#search' do
    let (:tim) { create(:business, first: "Tiny", last: "Tim", company_name: "The Golden Crutch", email: "tim@thegoldencrutch.com") }
    let (:betty) { create(:business, first: "Betty", last: "Boop", company_name: "Bangup Betty", email: "betty@bangupbetty.com") }

    context 'when there are no search params sent to the method' do
      it 'returns all businesses' do
        params = nil
        expect(Business.search(params)).to match_array(Business.all)
      end
    end

    context 'when params include first name' do
      it 'it includes the businesses that match the search paramters' do
        expect(Business.search("Tiny")).to include(tim)
      end

      it 'it does not include the businesses that match the search paramters' do
        expect(Business.search("Tiny")).not_to include(betty)
      end
    end

    context 'when params include last name' do
      it 'it includes the businesses that match the search paramters' do
        expect(Business.search("Tim")).to include(tim)
      end

      it 'it does not include the businesses that match the search paramters' do
        expect(Business.search("Tim")).not_to include(betty)
      end
    end

    context 'when params include comany_name' do
      it 'it includes the businesses that match the search paramters' do
        expect(Business.search("Golden")).to include(tim)
      end

      it 'it does not include the businesses that match the search paramters' do
        expect(Business.search("Golden")).not_to include(betty)
      end
    end

    context 'when params include email' do
      it 'it includes the businesses that match the search paramters' do
        expect(Business.search("tim")).to include(tim)
      end

      it 'it does not include the businesses that match the search paramters' do
        expect(Business.search("tim")).not_to include(betty)
      end
    end
  end

  describe '#update_after_mailer_delivery' do
    before do
      Timecop.freeze(DateTime.now)
    end

    it 'updates the business record' do
      business = create(:business, last_contacted_at: 2.days.ago, mailer_phase: "initial_intro")
      expect{ business.update_after_mailer_delivery("first_follow_up") }
        .to change { business.last_contacted_at }.from(2.days.ago).to(DateTime.now)
        .and change { business.mailer_phase }.from("initial_intro").to("first_follow_up")
    end
  end

  describe '#new?' do
    context 'when business is new' do
      it 'returns true' do
        business = build_stubbed(:business, mailer_phase: "initial_intro")
        expect(business.new?).to be true
      end
    end

    context 'when business is not new' do
      it 'returns false' do
        business = build_stubbed(:business, mailer_phase: "first_follow_up")
        expect(business.new?).to be false
      end
    end
  end

  # describe 'destroy_all_mailers' do
  #   let (:business) { create(:business_with_unscheduled_emails, emails_count: 1) }

  #   it 'removes any scheduled mailers for the business from sidekiq' do
  #     Sidekiq::Testing.fake!
  #     email = business.emails.first
  #     jid = MailerWorker.perform_in(1.day.from_now, email.id)
  #     email.update_attribute(:jid, jid)

  #     expect{ business.destroy_all_mailers }.to change { MailerWorker.jobs.size }.from(1).to(0)
  #   end

  #   it 'destroys all of the business emails' do
  #     expect{ business.destroy_all_mailers }.to change { business.emails.count }.from(1).to(0)
  #   end

  #   after do
  #     MailerWorker.jobs.clear
  #   end
  # end

  # describe 'stop_email_flow' do
  #   it 'removes any scheduled mailers for the business from sidekiq' do
  #     Sidekiq::Testing.fake!
  #     business = create(:business_with_unscheduled_emails, emails_count: 1)
  #     email = business.emails.first
  #     jid = MailerWorker.perform_in(1.day.from_now, email.id)
  #     email.update_attribute(:jid, jid)

  #     expect{ business.destroy_all_mailers }.to change { MailerWorker.jobs.size }.from(1).to(0)
  #   end

  #   it 'destroys all of the scheduled emails' do
  #     business = create(:business_with_scheduled_emails, emails_count: 1)

  #     expect{ business.destroy_all_mailers }.to change { business.emails.where(scheduled: true).count }.from(1).to(0)
  #   end

  #   after do
  #     MailerWorker.jobs.clear
  #   end
  # end
end
