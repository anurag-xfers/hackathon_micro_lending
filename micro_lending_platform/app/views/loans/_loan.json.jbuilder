json.extract! loan, :id, :amount, :period_in_days, :roi, :description, :created_at, :updated_at
json.url loan_url(loan, format: :json)
