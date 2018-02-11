# Http requests for all emails
class EmailsController < ApplicationController
  def index
    @emails = Email.all
  end

  def show
    email = Email.find(params[:id])
    business = Business.find(params[:business_id])
    render locals: { email: email, business: business }
  end
end
