class InboundEmailHandler
  attr_reader :new_messages

  def initialize(msgs)
    @new_messages = msgs
  end

  def process!
    businesses = fetch_businesses

    if businesses.present?
      businesses.each do |biz|
        email = create_incoming_email(biz)
        stop_emails_and_notify(biz, email) if biz.scheduled?
      end
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

  def stop_emails_and_notify(business, email)
    business.stop_email_flow
    notify!(business, email)
  end

  def notify!(business, email)
    Email.notify_admin(business)
    business.notifications.create!(
      body: "New email from #{business.company_name}",
      icon: "fa-envelope",
      email_id: email.id
    )
    business.update!(status: "response_received")
  end
end
