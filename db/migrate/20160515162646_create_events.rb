class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.references :organization, index: true
      t.integer :total_reach, default: 0
      t.integer :total_facebook_shares, default: 0
      t.integer :total_twitter_shares, default: 0
      t.integer :total_instagram_shares, default: 0
      t.integer :total_google_shares, default: 0

      t.timestamps
    end
  end
end
