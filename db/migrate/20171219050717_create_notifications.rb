class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :body, null: false
      t.string :icon, null: false
      t.belongs_to :email, index: true
      t.belongs_to :business, index: true

      t.timestamps
    end
  end
end
