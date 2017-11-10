class MailersController < ApplicationController
  def intro
    business = Business.find(params[:business_id])
    Mailer.intro(business, current_user).deliver_now

    flash[:notice] = "Intro mailer to #{business.company_name} sent!"
  rescue => e
    flash[:notice] = "Unable to send mailer because of an error: #{e.inspect}"
  ensure
    redirect_back(fallback_location: root_path)
  end

  def followup
    business = Business.find(params[:business_id])
    Mailer.followup(business, current_user).deliver_now

    flash[:notice] = "Followup mailer to #{business.company_name} sent!"
  rescue => e
    flash[:notice] = "Unable to send mailer because of an error: #{e.inspect}"
  ensure
    redirect_back(fallback_location: root_path)
  end
end
