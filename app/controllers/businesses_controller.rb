class BusinessesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  before_action :set_business_controller

  def index
    businesses = Business.search(params[:search])

    render locals: { businesses: businesses }
  end

  def show
  end

  def new
    @business = Business.new
  end

  def edit
  end

  def create
    @business = Business.new(business_params)

    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: "#{@business.company_name} was created successfully." }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to @business, notice: "#{@business.company_name} was updated successfully." }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url, notice: "#{@business.company_name} was deleted successfully." }
      format.json { head :no_content }
    end
  end

  def import
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

    business_count_before_import = Business.count
    customer_ids.each do |customer_id|
      customers_result = customers_api.retrieve_customer(customer_id)

      if customers_result.present?
        customers_result.customer.tap { |customer|
          last_order_placed = invoices.select { |i| i.tenders.map(&:customer_id).include?(customer_id) }.map(&:created_at).first

          if Business.where(email: customer.email_address, square_id: customer.id).empty?
            business = Business.create!(company_name: customer.company_name || "#{customer.given_name} #{customer.family_name}",
                                        email: customer.email_address,
                                        first: customer.given_name,
                                        last: customer.family_name,
                                        address: customer.address.try(:address_line_1),
                                        city: customer.address.try(:locality),
                                        state: customer.address.try(:administrative_district_level_1),
                                        postal_code: customer.address.try(:postal_code),
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

    if business_count_before_import < Business.count
      flash[:notice] = "Business data was successfully imported from Square."
    else
      flash[:notice] = "There waas no new business data to import from Square."
    end
  rescue => e
    flash[:notice] = "There was an error while importing data from Square: #{e}"
  ensure
    redirect_back(fallback_location: root_path)
  end

  private

  def set_business
    @business = Business.find(params[:id])
  end

  def business_params
    params.require(:business).permit(:company_name, :email, :first, :last, :address, :city,
                                     :state, :postal_code, :country, :last_contacted_at,
                                     :last_order_placed)
  end

  def set_business_controller
    @business_controller = true
  end
end
