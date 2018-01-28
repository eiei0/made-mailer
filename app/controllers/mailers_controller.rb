# Http requests for all mailers
class MailersController < ApplicationController
  before_action :fetch_business, only: %i[create destroy]

  def create
    if MailerBuilder.new(*builder_params).build!
      flash[:notice] =
        "#{params[:type].humanize} mailer sent to #{@business.company_name}."
    end
  rescue => e
    flash[:notice] = e.to_s
  ensure
    redirect_back(fallback_location: root_path)
  end

  def destroy
    stopped = @business.stop_email_flow
    @business.update!(status: 'pending', mailer_phase: nil)

    if stopped
      flash[:notice] =
        "All automated mailers stopped for #{@business.company_name}."
    end
  rescue => e
    flash[:notice] = e.to_s
  ensure
    redirect_back(fallback_location: root_path)
  end

  private

  def fetch_business
    @business = Business.find(params[:business_id])
  end

  def builder_params
    [@business, params[:type], params[:deliver_now], params[:delivery_date]]
  end
end
