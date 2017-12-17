class MailerWorker
  include Sidekiq::Worker

  def perform(email_id)
    email = Email.find(email_id)
    email.deliver!
  end

  def self.cancel!(jid)
    job = Sidekiq::ScheduledSet.new.find_job(jid)
    job.delete
  end
end
