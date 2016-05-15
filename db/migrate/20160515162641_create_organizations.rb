class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.string :account_type
      t.string :organization_type
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
