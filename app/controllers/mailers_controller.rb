class MailersController < ApplicationController
  def create
    if params[:business_id].present?
      business = Business.find(params[:business_id])
      MailerBuilder.new(business, params[:type]).build
      flash[:notice] = "#{params[:type].humanize} mailer to #{business.company_name} sent successfully!"
    elsif params[:business_ids].present?
      ids = params[:business_ids].split(",").map(&:to_i)
      businesses = Business.where(id: ids)
      businesses.each do |business|
        MailerBuilder.new(business, current_user, params[:type]).build
      end
      flash[:notice] = "#{businesses.count} mailers have been sent successfully!"
    else
      raise "Please select a business before sending a mailer."
    end
  rescue => e
    flash[:notice] = "#{e}"
  ensure
    redirect_back(fallback_location: root_path)
  end
end
