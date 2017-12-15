class DashboardController < ApplicationController
  def index
    @mailers_count = Email.mailers_delivered(1.weeks.ago).count
    @mailers_scheduled = Email.where(scheduled: true).count
    @new_orders = 0 # Will obviously populate orders from Square here
    @unresponsive = 0 # Will obviously populate unresponsive orders here
    # @notifications = Notifications.last(8).reverse
  end
end
