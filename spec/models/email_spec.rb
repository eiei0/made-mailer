# frozen_string_literal: true

require "rails_helper"

RSpec.describe Business do
  describe "#schedule_mailer" do
    it "schedules a sidekiq worker to send email and updates the jid attr for the email" do
      email = create(:email_with_business)

      Sidekiq::Testing.fake! do
        expect { email.schedule_mailer }
          .to change { MailerWorker.jobs.size }.from(0).to(1)
          .and change { email.jid }
      end
    end
  end

  describe "#deliver!" do
    it "delivers the email and updates the email attributes to reflect that it has been sent" do
      email = create(:email_with_business, :scheduled)

      expect { email.deliver! }
        .to change { ActionMailer::Base.deliveries.size }.by(1)
        .and change { email.scheduled }.from(true).to(false)
        .and change { email.delivery_date }
    end
  end

  describe "#schedule_or_deliver" do
    context "when the email is scheduled" do
      it "schedules the mailer" do
        email = Email.new
        allow(email).to receive(:scheduled?).and_return(true)
        allow(email).to receive(:schedule_mailer).and_return(nil)

        email.schedule_or_deliver

        expect(email).to have_received(:schedule_mailer)
      end
    end

    context "when the email is not scheduled" do
      it "delivers the mailer instantly" do
        email = Email.new
        allow(email).to receive(:scheduled?).and_return(false)
        allow(email).to receive(:deliver!).and_return(nil)

        email.schedule_or_deliver

        expect(email).to have_received(:deliver!)
      end
    end
  end

  describe "#mailers_delivered" do
    it "fetches all mailers that have been delivered and are not scheduled" do
      email = create(:email_with_business, :unscheduled, delivery_date: 1.day.from_now)

      expect(Email.mailers_delivered(DateTime.now)).to match_array([email])
    end
  end
end
