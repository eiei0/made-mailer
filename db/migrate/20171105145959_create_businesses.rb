class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|
      t.string :company_name, null: false
      t.string :email, null: false
      t.string :first
      t.string :last
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :square_id
      t.string :mailer_phase
      t.datetime :last_contacted_at
      t.datetime :last_order_placed

      t.timestamps
    end
  end
end
