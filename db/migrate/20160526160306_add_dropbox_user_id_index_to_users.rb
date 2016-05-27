class AddDropboxUserIdIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :dropbox_user_id
  end
end
