class MailerBuilder
  attr_accessor :intro, :followup, :business, :type

  def initialize(business, current_user, type)
    @intro = Mailer.intro(business, current_user)
    @followup = Mailer.followup(business, current_user)
    @business = business
    @type = type
  end

  def build
    case type
    when "intro"
      IntroBuilder.build(intro, business)
    when "followup"
      FollowupBuilder.build(followup, business)
    end
  end

  class IntroBuilder < MailerBuilder
    def self.build(intro, business)
      intro.deliver_now!
      business.emails.create!(classification: 0)
    end
  end

  class FollowupBuilder < MailerBuilder
    def self.build(followup, business)
      followup.deliver_now!
      business.emails.create!(classification: 1)
    end
  end
end
