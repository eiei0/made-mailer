# frozen_string_literal: true

# Rails
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
