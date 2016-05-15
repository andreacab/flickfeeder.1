class CreateDeviceHealths < ActiveRecord::Migration
  def change
    create_table :device_healths do |t|
      t.string :current_battery_charge
      t.references :f_fdevice, index: true
      t.string :available_storage
      t.string :health
      t.string :network_signal
      t.string :available_mobile_data
      t.references :user, index: true

      t.timestamps
    end
  end
end
