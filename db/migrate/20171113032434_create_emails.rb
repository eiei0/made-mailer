class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.belongs_to :business, index: true
      t.column :classification, :integer, default: 0

      t.timestamps
    end
  end
end
