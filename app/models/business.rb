# Stores information about a business.
class Business < ApplicationRecord
  has_many :emails, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :company_name, :email, presence: true
  validates :email, unique_custom_domain: true, if: :new_and_custom_domain?

  before_save :downcase_email
  before_create :default_status
  before_validation :smart_add_url_protocol, if: :url?

  enum status: {
    pending: 0,
    current_wholesale_vendor: 1,
    current_consignment_vendor: 2,
    declined: 3,
    followup_later: 4,
    response_received: 5,
    unresponsive: 6
  }

  enum mailer_option: { new_business: 'new_business',
                        reintroduction: 'reintroduction',
                        reorder_inquiry: 'reorder_inquiry' }

  scope :email_like, ->(search) { where('email ILIKE ANY (array[?])', search) }

  def default_status
    self.status = 0
  end

  def primary_contact_name
    "#{first} #{last}".strip
  end

  def scheduled?
    emails.scheduled.present?
  end

  def responded?
    status == 'response_received'
  end

  def notified?
    notifications.where(icon: 'fa-reply-all').present?
  end

  def already_notified?
    responded? && !notified?
  end

  def notify_admin
    return unless already_notified?
    Mailer.admin_response_notification(self).deliver!
    create_notification!(company_name, 'fa-reply-all')
  end

  def transition
    cancel_mailers(all_jids) if scheduled?
    update!(status: 'response_received')
  end

  def self.search(search)
    search ? Business.query_for(search) : all
  end

  def self.query_for(search)
    where(
      'first ILIKE ? OR last ILIKE ? OR company_name ILIKE ? OR email ILIKE ?',
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"
    )
  end

  def update_after_mailer_delivery(mailer_phase)
    update(
      last_contacted_at: DateTime.now.in_time_zone,
      mailer_phase: mailer_phase
    )
  end

  def new?
    [nil, 'initial_intro'].include?(mailer_phase)
  end

  def destroy_all_mailers
    cancel_mailers(emails.map(&:jid))
    emails.destroy_all
  end

  def stop_email_flow
    cancel_mailers(all_jids)
    emails.where(scheduled: true).destroy_all
  end

  def create_notification!(body, icon)
    notifications.create!(body: body, icon: icon)
  end

  def cancel_mailers(jids)
    jids.each do |jid|
      MailerWorker.cancel!(jid)
    end
  end

  def all_jids
    emails.map(&:jid)
  end

  def email_domain
    email.split('@')[1]
  end

  private

  def smart_add_url_protocol
    match = url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
    self.url = "http://#{url}" unless match
  end

  def downcase_email
    email.downcase!
  end

  def new_and_custom_domain?
    return false if persisted?
    Email::COMMON_DOMAINS.exclude?(email_domain)
  end
end
