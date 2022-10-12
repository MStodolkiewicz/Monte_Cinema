json.discounts do
  json.array! @discounts, partial: "discounts/discount", as: :discount
end
