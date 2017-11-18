class ReportsController < ApplicationController
  def index
    months = Date::MONTHNAMES.compact
    products = Product.all

    render locals: { products: products, months: months }
  end
end
