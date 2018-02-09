# Encapsulation of all necessary logic to create and update a Business
class BusinessForm
  include ActiveModel::Model

  attr_reader   :business_params
  attr_accessor :company_name, :email, :first, :last, :url, :delivery_date,
                :notes, :deliver_now, :address, :city, :state, :postal_code,
                :country, :status, :phone, :connection_point

  # validates :business_params, presence: true, if: :business_params_valid?
  validates :delivery_date, presence: true, if: :scheduled?

  def initialize(attrs = {})
    @business_params = attrs.except(:delivery_date, :deliver_now)
    @deliver_now = attrs[:deliver_now]
    @delivery_date = attrs[:delivery_date]
  end

  def persist!
    # if valid?
    ActiveRecord::Base.transaction do
      business = create_business
      build_emails(business)
      business
    end
  end

  private

  def create_business
    Business.create!(
      business_params.merge('status' => business_params[:status].underscore)
    )
  end

  def build_emails(business)
    builder = MailerBuilder.new(
      business, 'initial_intro', deliver_now, delivery_date
    )
    builder.build!
  end

  def scheduled?
    deliver_now == false && delivery_date.present?
  end

  def business_params_valid?
    required_keys = %i[company_name email]
    required_keys
      .all? { |k| business_params.key?(k) && business_params[k].present? }
  end
end
