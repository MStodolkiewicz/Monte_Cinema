json.halls do
  json.array! @halls, partial: "halls/hall", as: :hall
end
