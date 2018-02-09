# Http requests for all emails
class EmailsController < ApplicationController
  def show
    email = Email.find(params[:id])
    render locals: { email: email }
  end
end
