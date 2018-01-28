# Http requests for all notifications
class NotificationsController < ApplicationController
  def create
  end

  def index
    @notifications = Notification.all
  end
end
