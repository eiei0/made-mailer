# frozen_string_literal: true

# Handles importing business data from Square
class SquareBusinessImport
  def initialize
    @locations_api ||= SquareConnect::LocationsApi.new
    @customers_api ||= SquareConnect::CustomersApi.new
    @transactions_api ||= SquareConnect::TransactionsApi.new
  end

  attr_accessor :locations_api, :customers_api, :transactions_api

  def run
    customer_ids.each do |customer_id|
      next if customers_result(customer_id).blank?

      customers_result.customer.tap do |customer|
        Business.find_or_create!(business_params(customer, customer_id))
      end
    end
  end

  private

  def company_name
    customer.company_name || "#{customer.given_name} #{customer.family_name}"
  end

  def location_id
    locations_api.list_locations.locations.first.id
  end

  def transactions_result
    opts =
      { begin_time: DateTime.now.in_time_zone - 2.years,
        end_time: DateTime.now.in_time_zone }
    transactions_api.list_transactions(location_id, opts)
  end

  def invoices
    transactions_result.transactions.select do |t|
      t.product == "INVOICES"
    end
  end

  def customer_ids
    ids = []
    invoices.each do |i|
      ids << i.tenders.map(&:customer_id)
    end
    ids.flatten!
  end

  def customer_result(customer_id)
    customers_api.retrieve_customer(customer_id)
  end

  def last_order_placed(customer_id)
    invoices.select do |i|
      i.tenders.map(&:customer_id).include?(customer_id)
    end.map(&:created_at).first
  end

  def business_params(customer, customer_id)
    { company_name: company_name, email: customer.email_address,
      first: customer.given_name, last: customer.family_name,
      address: customer.address.try(:address_line_1),
      city: customer.address.try(:locality),
      state: customer.address.try(:administrative_district_level_1),
      postal_code: customer.address.try(:postal_code), country: nil,
      square_id: customer.id, last_order_placed: last_order_placed(customer_id),
      created_at: customer.created_at }
  end
end
