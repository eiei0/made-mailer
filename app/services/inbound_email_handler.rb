# Queries the business table for matching email
#   addresses from the sender and stops the
#   automated email flow for that business.
class InboundEmailHandler
  attr_reader :new_messages

  def initialize(msgs)
    @new_messages = msgs
  end

  def process!
    businesses = fetch_businesses

    businesses.each do |biz|
      email = create_incoming_email(biz)

      biz.cancel_mailers(biz.all_jids) if biz.scheduled?
      biz.update!(status: "response_received") if biz.mailer_phase.present?
      notify!(biz, email) if biz.responded? && !biz.notified?
    end
  rescue => e
    raise "#{e}"
  end

  private

  def fetch_businesses
    search = new_messages.flat_map do |msg|
      email_address = Mail::Address.new(msg.from.first.downcase)
      domain = email_address.domain
      Email::COMMON_DOMAINS.include?(domain) ? "%#{email_address}%" : "%@#{domain}%"
    end

    Business.where("email ILIKE ANY ( array[?] )", search)
  end

  def create_incoming_email(business)
    business.emails.create!(
      classification: "inbound",
      scheduled: false,
      jid: nil,
      delivery_date: nil
    )
  end

  def notify!(business, email)
    Email.notify_admin(business)
    business.create_notification!(business.company_name, "fa-reply-all")
  end
end
