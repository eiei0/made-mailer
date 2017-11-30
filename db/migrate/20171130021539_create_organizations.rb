class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :address
      t.string :state
      t.string :zip
      t.string :country

      t.timestamps
    end
  end
end
