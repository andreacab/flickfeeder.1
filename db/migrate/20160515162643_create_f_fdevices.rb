class CreateFFdevices < ActiveRecord::Migration
  def change
    create_table :f_fdevices do |t|
      t.string :name
      t.references :organization, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
