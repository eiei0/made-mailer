class MailerBuilder
  attr_accessor :initial_intro, :one_week_intro, :two_week_intro,
    :one_month_followup, :business, :type

  def initialize(business, type)
    @initial_intro = Mailer.initial_intro(business)
    @one_week_intro = Mailer.one_week_intro(business)
    @two_week_intro = Mailer.two_week_intro(business)
    @one_month_followup = Mailer.one_month_followup(business)
    @business = business
    @type = type
  end

  def build
    case type
    when "initial_intro"
      IntroBuilder.build(initial_intro, business, 0)
    when "one_week_intro"
      IntroBuilder.build(one_week_intro, business, 1)
    when "two_week_intro"
      IntroBuilder.build(two_week_intro, business, 2)
    when "one_month_followup"
      FollowupBuilder.build(one_month_followup, business, 3)
    end
  end

  class IntroBuilder < MailerBuilder
    def self.build(intro, business, classification)
      intro.deliver_now!
      business.emails.create!(classification: classification)
    end
  end

  class FollowupBuilder < MailerBuilder
    def self.build(followup, business, classification)
      followup.deliver_now!
      business.emails.create!(classification: classification)
    end
  end
end
