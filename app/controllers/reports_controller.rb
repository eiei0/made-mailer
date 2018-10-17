# frozen_string_literal: true

# Http requests for all reports
class ReportsController < ApplicationController
  def cog
    months = Date::MONTHNAMES.compact
    products = Product.all

    render locals: { products: products, months: months }
  end

  def mailers_sent; end
end
