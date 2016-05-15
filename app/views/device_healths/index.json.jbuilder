json.array!(@device_healths) do |device_health|
  json.extract! device_health, :id, :current_battery_charge, :f_fdevice_id, :available_storage, :health, :network_signal, :available_mobile_data, :user_id
  json.url device_health_url(device_health, format: :json)
end
