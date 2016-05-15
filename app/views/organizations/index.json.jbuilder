json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name, :address, :account_type, :organization_type, :phone, :email
  json.url organization_url(organization, format: :json)
end
