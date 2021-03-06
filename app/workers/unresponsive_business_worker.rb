# frozen_string_literal: true

require "sidekiq-scheduler"

# Responsible for marking businesses as unresponsive if we have
#   not recieved any emails from them.
class UnresponsiveBusinessWorker
  include Sidekiq::Worker

  def perform
    businesses =
      Business.where(mailer_phase: "second_follow_up")
        .select do |b|
        DateTime.now.in_time_zone > b.last_contacted_at + 2.weeks
      end

    return if businesses.blank?

    businesses.map do |b|
      b.update(status: "unresponsive")
    end
  end
end
