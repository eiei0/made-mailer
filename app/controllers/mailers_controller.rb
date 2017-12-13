class MailersController < ApplicationController
  def create
    business = Business.find(params[:business_id])
    MailerBuilder.new(business, params[:type]).build
    flash[:notice] = "#{params[:type].humanize} mailer to #{business.company_name} sent successfully!"
  rescue => e
    flash[:notice] = "#{e}"
  ensure
    redirect_back(fallback_location: root_path)
  end
end
