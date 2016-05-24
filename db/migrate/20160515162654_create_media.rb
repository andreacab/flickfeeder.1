class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :type_of_media
      t.references :user, index: true
      t.references :organization, index: true
      t.references :event, index: true
      t.string :url
      t.string :thumbnail
      t.integer :facebook_shares, default: 0
      t.integer :instagram_shares, default: 0
      t.integer :twitter_shares, default: 0
      t.integer :google_shares, default: 0
      t.boolean :show_clients, default: true
      t.references :token, index: true

      t.timestamps
    end
  end
end
