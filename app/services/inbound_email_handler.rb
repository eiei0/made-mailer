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
    sender_domains = new_messages.flat_map { |msg| "@" + Mail::Address.new(msg.from.first.downcase).domain }
    domains_with_percentage_signs = sender_domains.map { |val| "%#{val}%" }
    Business.where("email ILIKE ANY ( array[?] )", domains_with_percentage_signs)
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
