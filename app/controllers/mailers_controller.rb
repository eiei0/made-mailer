class MailersController < ApplicationController
  before_action :fetch_business, only: [:create, :destroy]

  def create
    builder = MailerBuilder.new(@business, params[:type], params[:deliver_now], params[:delivery_date])

    flash[:notice] = "#{params[:type].humanize} mailer to #{@business.company_name} sent successfully!" if builder.build!
  rescue => e
    flash[:notice] = "#{e}"
  ensure
    redirect_back(fallback_location: root_path)
  end

  def destroy
    stopped = @business.stop_email_flow
    @business.update!(status: "pending", mailer_phase: nil)

    flash[:notice] = "All automated mailers for #{@business.company_name} were stopped successfully." if stopped
  rescue => e
    flash[:notice] = "#{e}"
  ensure
    redirect_back(fallback_location: root_path)
  end

  private

  def fetch_business
    @business = Business.find(params[:business_id])
  end
end
