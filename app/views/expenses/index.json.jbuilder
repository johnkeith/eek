json.array!(@expenses) do |expense|
  json.extract! expense, :id, :user_id, :date, :reseller, :item_or_service, :payment_form, :charged_to, :cost, :amount_from_budget, :notes
  json.url expense_url(expense, format: :json)
end
