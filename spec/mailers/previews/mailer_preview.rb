class MailerPreview < ActionMailer::Preview
  def initial_intro
    Mailer.initial_intro(Business.first)
  end

  def first_follow_up
    Mailer.first_follow_up(Business.first)
  end

  def second_follow_up
    Mailer.second_follow_up(Business.first)
  end

  def post_purchase_check_in
    Mailer.post_purchase_check_in(Business.first)
  end

  def admin_response_notification
    Mailer.admin_response_notification(Business.first)
  end
end
