class ImapWorker
  include Sidekiq::Worker

  def perform
    new_messages = ZohoImap.new.poll
    return unless new_messages.present?

    InboundEmailHandler.new(new_messages).process!
  end
end
