class AddOrganizationsToModels < ActiveRecord::Migration[5.1]
  def change
    add_reference :businesses, :organization, foreign_key: true
    add_reference :products, :organization, foreign_key: true
    add_reference :organizations, :user, foreign_key: true
  end
end
