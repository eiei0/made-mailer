# frozen_string_literal: true

# Queries the business table for matching email addresses from the sender and
# stops the automated email flow for that business.
class InboundEmailHandler
  attr_reader :new_messages

  def initialize(msgs)
    @new_messages = msgs
  end

  def process!
    new_messages.flat_map do |msg|
      next unless (business = fetch_business(msg)) && !business&.responded?

      business.emails.create_inbound_email!(msg)
      business.transition
      business.notify_admin
    end
  rescue StandardError => e
    raise e.to_s
  end

  private

  def fetch_business(msg)
    email_address = Mail::Address.new(msg.from.first.downcase)
    search =
      if Email::COMMON_DOMAINS.include?(email_address.domain)
        "%#{email_address}%"
      else
        "%@#{email_address.domain}%"
      end

    Business.email_like(search).first
  end
end
