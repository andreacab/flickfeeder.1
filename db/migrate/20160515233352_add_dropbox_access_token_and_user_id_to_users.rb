class AddDropboxAccessTokenAndUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_access_token, :string
    add_column :users, :dropbox_user_id, :string
  end
end
