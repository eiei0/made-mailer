# frozen_string_literal: true

require "sidekiq-scheduler"

# Used to fetch new messages and send them
#   to the inbound email handler.
class ImapWorker
  include Sidekiq::Worker

  def perform
    new_messages = ZohoImap.new.poll
    return if new_messages.blank?

    InboundEmailHandler.new(new_messages).process!
  end
end
