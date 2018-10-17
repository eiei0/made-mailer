# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string    :name, null: false
      t.monetize  :price, default: nil

      t.timestamps
    end
  end
end
