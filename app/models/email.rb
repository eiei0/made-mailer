# Records that track the status of inbound/outbound mailers
class Email < ApplicationRecord
  COMMON_DOMAINS =
    %w[aol.com att.net comcast.net facebook.com gmail.com gmx.com googlemail.com
       google.com hotmail.com hotmail.co.uk mac.com me.com mail.com msn.com
       live.com sbcglobal.net verizon.net yahoo.com yahoo.co.uk email.com
       fastmail.fm games.com gmx.net hush.com hushmail.com icloud.com iname.com
       inbox.com lavabit.com love.com outlook.com pobox.com protonmail.com
       rocketmail.com safe-mail.net wow.com ygm.com ymail.com zoho.com
       yandex.com bellsouth.net charter.net cox.net earthlink.net
       juno.com].freeze

  belongs_to :business

  validates :classification, presence: true

  scope :scheduled, -> { where('delivery_date > ?', DateTime.now.in_time_zone) }

  enum classification: {
    initial_intro: 0,
    first_follow_up: 1,
    second_follow_up: 2,
    retry_intro: 3,
    inbound: 4,
    post_purchase_check_in: 5
  }

  def business_name
    business.company_name
  end

  def color
    if delivery_date > Time.now
      "#f0ad4e"
    else
      "#337ab7"
    end
  end

  def schedule_mailer
    jid = MailerWorker.perform_in(delivery_date, id)
    update_attributes(jid: jid)
    business.create_notification!(business.company_name, 'fa-clock-o')
  end

  def deliver!
    # consider switch to MailerWorker.perform_async(classification.to_sym, id)
    mailer = Mailer.public_send(classification.to_sym, business)
    return unless (email = mailer.deliver!)

    update_records(Mail.new(email))
    business.create_notification!(business.company_name, 'fa-envelope')
  end

  def schedule_or_deliver
    if scheduled?
      schedule_mailer
    else
      deliver!
    end
  end

  def self.mailers_delivered(start_date)
    where(scheduled: false).where('delivery_date > ?', start_date)
  end

  def self.notify_admin(business)
    Mailer.admin_response_notification(business).deliver!
  end

  private

  def update_records(email)
    update_attributes(scheduled: false,
                      delivery_date: DateTime.now.in_time_zone,
                      subject: email.subject,
                      body: email.parts.first.body.to_s.html_safe)
    business.update_after_mailer_delivery(classification)
  end
end
