# frozen_string_literal: true

# Http requests for Businesses
class BusinessesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business, only: %i[show edit update destroy]
  before_action :detect_index_action

  def index
    businesses = Business.search(params[:search])

    render locals: { businesses: businesses }
  end

  def show; end

  def new
    @business = BusinessForm.new
  end

  def edit; end

  def create
    @business = BusinessForm.new(business_form_params)

    return unless (business_record = @business.persist!)

    flash[:notice] = "#{business_record.company_name} was created successfully."
    redirect_to businesses_path
  rescue StandardError => e
    flash[:notice] = "Unable to create business: #{e}"
    redirect_back(fallback_location: new_business_path)
  end

  def update
    return unless @business.update(business_update_params)

    redirect_to(@business)
    flash[:notice] = "#{@business.company_name} was updated successfully."
  rescue StandardError => e
    flash[:notice] = "Unable to update business: #{e}"
    redirect_back(fallback_location: business_path(params[:id]))
  end

  def destroy
    ActiveRecord::Base.transaction do
      @business.destroy_all_mailers
      @business.destroy
    end
    redirect_to businesses_url, notice:
      "#{@business.company_name} was deleted successfully."
  end

  def import
    flash[:notice] =
      if SquareBusinessImport.new.run < Business.count
        "Business data was successfully imported from Square."
      else
        "There waas no new business data to import from Square."
      end
  rescue StandardError => e
    flash[:notice] = "There was an error while importing data from Square: #{e}"
  ensure
    redirect_back(fallback_location: root_path)
  end

  private

  def set_business
    @business = Business.find(params[:id])
  end

  def business_params
    params.require(:business).permit(:company_name, :email, :first, :last,
      :address_1, :address_2, :city, :state,
      :postal_code, :country, :last_contacted_at,
      :last_order_placed, :url, :notes, :status,
      :connection_point, :phone)
  end

  def business_form_params
    params.require(:business_form).permit(:company_name, :email, :first, :last,
      :delivery_date, :deliver_now,
      :address_1, :address_2, :city, :state,
      :postal_code, :country, :url, :notes,
      :status, :connection_point, :phone)
  end

  def detect_index_action
    @business_index = (action_name == "index")
  end

  def business_update_params
    business_params
      .merge('status': business_params[:status]
      .split(" ").join.underscore)
  end
end
