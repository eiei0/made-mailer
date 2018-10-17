# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailerBuilder do
  describe "#build!" do
    let (:business) { create(:business) }
    let (:builder) { MailerBuilder.new(business, "initial_intro", nil, nil) }

    it "creates one initial_intro and two followup email records" do
      builder.deliver_now = 0
      builder.delivery_date = DateTime.current
      e = business.emails

      expect { builder.build! }
        .to change { e.where(classification: "initial_intro").count }
        .from(0).to(1)
        .and change { e.where.not(classification: "initial_intro").count }
        .from(0).to(2)
    end

    context "initial intro mailer is sent with deliver now selected" do
      before do
        builder.deliver_now = 0
        builder.delivery_date = DateTime.current
      end

      it "delivers the mailer now" do
        expect { builder.build! }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "schedules the followup mailers via sidekiq" do
        expect { builder.build! }.to change { MailerWorker.jobs.size }.by(2)
      end
    end

    context "initial intro mailer is scheduled for a future date" do
      before do
        builder.deliver_now = 1
        builder.delivery_date = 2.weeks.from_now
      end

      it "schedules all three mailers via sidekiq" do
        expect { builder.build! }.to change { MailerWorker.jobs.size }.by(3)
      end
    end
  end
end
