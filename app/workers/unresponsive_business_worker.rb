require 'sidekiq-scheduler'

class UnresponsiveBusinessWorker
  include Sidekiq::Worker

  def perform
    businesses = Business
      .where(mailer_phase: "second_follow_up")
      .select { |b| DateTime.now > b.last_contacted_at + 2.weeks }

    businesses.map { |b| b.update_attribute :status, "unresponsive" } if businesses.present?
  end
end
