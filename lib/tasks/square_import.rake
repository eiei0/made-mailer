require 'square_connect'

namespace 'square' do
  desc "Import businesses from Square platform"
  task import_business: :environment do
    locations_api = SquareConnect::LocationsApi.new
    customers_api = SquareConnect::CustomersApi.new
    transactions_api = SquareConnect::TransactionsApi.new

    location_id = locations_api.list_locations.locations.first.id

    opts = { begin_time: DateTime.now - 2.year, end_time: DateTime.now }
    transactions_result = transactions_api.list_transactions(location_id, opts)

    invoices = transactions_result.transactions.select { |t| t.product == "INVOICES" }
    customer_ids = []
    invoices.each do |i|
      customer_ids << i.tenders.map(&:customer_id)
    end
    customer_ids.flatten!

    customer_ids.each do |customer_id|
      customers_result = customers_api.retrieve_customer(customer_id)

      if customers_result.present?
        customers_result.customer.tap { |customer|
          last_order_placed = invoices.select { |i| i.tenders.map(&:customer_id).include?(customer_id) }.map(&:created_at).first

          if Business.where(email: customer.email_address, square_id: customer.id).empty?
            business = Business.create_or_update!(company_name: customer.company_name || "#{customer.given_name} #{customer.family_name}",
                                                  email: customer.email_address,
                                                  first: customer.given_name,
                                                  last: customer.family_name,
                                                  address: customer.address.address_line_1,
                                                  city: customer.address.locality,
                                                  state: customer.address.administrative_district_level_1,
                                                  postal_code: customer.address.postal_code,
                                                  country: nil,
                                                  square_id: customer.id,
                                                  last_order_placed: last_order_placed,
                                                  created_at: customer.created_at
                                                 )
            puts "Created #{business.company_name}"
          end
        }
      else
        next
      end
    end
  end
end
