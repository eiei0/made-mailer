class DashboardController < ApplicationController
  def index
    @mailers_count = Email.mailers_delivered(1.week.ago).count
    @mailers_scheduled = Email.where(scheduled: true).where('delivery_date < ?', 1.week.from_now).count
    @unresponsive = Business.where(status: "unresponsive").where('last_contacted_at > ?', 1.week.ago).count
    @new_responses = Business.where(status: "response_received").where('updated_at > ?', 1.week.ago).count
    @notifications = Notification.last(8).reverse
  end
end
