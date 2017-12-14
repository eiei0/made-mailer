class MailersController < ApplicationController
  def create
    business = Business.find(params[:business_id])
    builder = MailerBuilder.new(business, params[:type], params[:deliver_now], params[:delivery_date])

    flash[:notice] = "#{params[:type].humanize} mailer to #{business.company_name} sent successfully!" if builder.build!
  rescue => e
    flash[:notice] = "#{e}"
  ensure
    redirect_back(fallback_location: root_path)
  end
end
