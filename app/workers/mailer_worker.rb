class MailerWorker
  include Sidekiq::Worker

  def perform(email_id)
    email = Email.find(email_id)
    email.deliver!
  end
end
