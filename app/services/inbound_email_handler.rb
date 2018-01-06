class InboundEmailHandler
  attr_reader :new_messages

  def initialize(msgs)
    @new_messages = msgs
  end

  def process!
    businesses = fetch_businesses

    if businesses.present?
      businesses.each do |biz|
        stop_emails(biz) if biz.scheduled?
        biz.update!(status: "response_received")
      end
    end
  rescue => e
    raise "Authentication failed: #{e}"
  end

  private

  def fetch_businesses
    Business.where(email: new_messages.flat_map(&:from))
  end

  def stop_emails(business)
    business.stop_email_flow
    Email.notify_admin(business)
  end
end
