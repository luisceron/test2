json.array!(@accounts) do |account|
  json.extract! account, :id, :user_id, :type, :name, :balance, :description
  json.url account_url(account, format: :json)
end
