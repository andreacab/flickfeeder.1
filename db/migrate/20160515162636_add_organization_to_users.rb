class AddOrganizationToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :organization, index: true, default: 1
  end
end
