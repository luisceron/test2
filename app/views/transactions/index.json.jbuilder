json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :user_id, :account_id, :category_id, :transaction_type, :date, :amount, :description
  json.url transaction_url(transaction, format: :json)
end
