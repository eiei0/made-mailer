class BusinessForm
  include ActiveModel::Model

  attr_reader :business_params, :email_params
  attr_accessor :company_name, :email, :first, :last, :delivery_date,
    :deliver_now, :address, :city, :state, :postal_code, :country

  # validates :company_name, presence: true # validates :email, presence: true

  def initialize(attrs = {})
    @business_params = attrs.except(:delivery_date, :deliver_now)
    @email_params = {
      classification: 0,
      scheduled: (attrs[:deliver_now].present? ? 1 : 0),
      deliver_date: (attrs[:delivery_date].present? ? attrs[:delivery_date] : DateTime.now)
    }
  end

  def persist!
    if valid?
      ActiveRecord::Base.transaction do
        business = create_business
        email = create_email(business)
        schedule_or_deliver_email(business, email)
        business
      end
    end
  end

  private

  def create_business
    Business.create!(business_params)
  end

  def create_email(business)
    Email.create!(email_params.merge(business_id: business.id))
  end

  def schedule_or_deliver_email(business, email)
    if email.scheduled?
      MailerBuilder.new(business, "initial_intro", email).build
    else
      email.deliver!
    end
  end
end
