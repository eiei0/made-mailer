# frozen_string_literal: true

# Fetches all necessary objects to build the dashboard
class CalendarBuilder
  attr_accessor :from, :to

  def initialize(from, to)
    @from = from
    @to = to
  end

  def build
    emails_to_include - emails_to_exclude
  end

  private

  def emails_to_include
    Email
      .includes(:business)
      .within(from, to)
      .where(classification: 0..2)
  end

  def emails_to_exclude
    Email
      .includes(:business)
      .within(from, to)
      .where(classification: 4)
      .flat_map { |e| e.business.emails }
      .select(&:scheduled)
  end
end
