# frozen_string_literal: true

json.array!(@emails) do |email|
  json.id email.id
  json.title email.business_name
  json.description email.classification.humanize.downcase
  json.start email.delivery_date
  json.end email.delivery_date + 10.minutes
  json.color email.color
  json.url email_url(id: email, business_id: email.business.id, format: :html) if email.body.present?
end
