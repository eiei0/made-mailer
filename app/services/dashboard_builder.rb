# Fetches all necessary objects to build the dashboard
class DashboardBuilder
  def self.mailers_count
    @mailers_count = Email.mailers_delivered(1.week.ago).count
  end

  def self.mailers_scheduled
    @mailers_scheduled = Email.where(scheduled: true)
                              .where('delivery_date < ?', 1.week.from_now)
                              .count
  end

  def self.unresponsive
    @unresponsive = Business.where(status: 'unresponsive')
                            .where('last_contacted_at > ?', 1.week.ago).count
  end

  def self.new_responses
    @new_responses = Business.where(status: 'response_received')
                             .where('updated_at > ?', 1.week.ago).count
  end

  def self.notifications
    @notifications = Notification.last(8).reverse
  end
end
