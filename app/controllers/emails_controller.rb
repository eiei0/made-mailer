# Http requests for all emails
class EmailsController < ApplicationController
  def show
    email = Email.find(params[:id])
    business = Business.find(params[:business_id])
    render locals: { email: email, business: business }
  end
end
