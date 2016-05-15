class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :type_of_media
      t.references :user, index: true
      t.references :organization, index: true
      t.references :event, index: true
      t.string :url
      t.string :thumbnail

      t.timestamps
    end
  end
end
