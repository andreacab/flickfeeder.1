json.array!(@f_fdevices) do |f_fdevice|
  json.extract! f_fdevice, :id, :name, :organization_id, :user_id
  json.url f_fdevice_url(f_fdevice, format: :json)
end
