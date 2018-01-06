require 'net/imap'

class ZohoImap
  attr_reader :client

  def initialize
    @client ||= Net::IMAP.new("imap.zoho.com", 993, true)
  end

  def poll
    connect!
    fetch_new_messages
  rescue => e
    raise "Authentication failed: #{e}"
  end

  private

  def connect!
    client.authenticate('PLAIN', ENV['stacy_email'], ENV['zoho_password'])
  end

  def fetch_new_messages
    messages = []
    client.select('INBOX')
    unread_message_ids = client.search(["UNSEEN"])
    unread_message_ids.each do |id|
      raw_message = client.fetch(id,'RFC822').first.attr['RFC822']
      message = Mail.read_from_string raw_message
      messages << message
    end
    messages
  end
end
