class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.boolean :dashboard, default: true
      t.boolean :events, default: true
      t.boolean :devices_health, default: true
      t.boolean :photo_stream, default: true
      t.boolean :team, default: true
      t.boolean :image_design, default: "true"

      t.timestamps
    end
  end
end
