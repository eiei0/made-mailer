# frozen_string_literal: true

# Custom validation for the Business#email that checks for a unique domain
# on that column if it is a custom domain.
class UniqueCustomDomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return if no_other_emails_like?(record.email_domain)

    record.errors.add(attribute, "must have a unique custom domain")
  end

  private

  def no_other_emails_like?(domain)
    Business.email_like("%@#{domain}%").blank?
  end
end
