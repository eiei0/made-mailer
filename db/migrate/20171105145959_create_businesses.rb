# frozen_string_literal: true

class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|
      t.string :company_name, null: false
      t.string :email, null: false
      t.string :url
      t.string :first
      t.string :last
      t.string :phone
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :square_id
      t.string :mailer_phase
      t.text   :notes
      t.text   :connection_point
      t.column :status, :integer
      t.datetime :last_contacted_at
      t.datetime :last_order_placed

      t.timestamps
    end
  end
end
