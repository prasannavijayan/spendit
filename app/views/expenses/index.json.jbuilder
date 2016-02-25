json.array!(@expenses) do |expense|
  json.extract! expense, :id, :title, :amount
  json.url expense_url(expense, format: :json)
end
