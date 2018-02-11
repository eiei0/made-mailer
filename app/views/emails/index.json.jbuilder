json.array!(@emails) do |email|
  json.id email.id
  json.title email.business_name
  json.description email.classification.humanize.downcase
  json.start email.delivery_date
  json.end email.delivery_date + 10.minutes
  json.color email.color
  if email.body.present?
    json.url email_url(id: email, business_id: email.business.id, format: :html)
  end
end
