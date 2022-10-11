json.movies do
  json.array! @movies, partial: "movies/movie", as: :movie
end

json.discounts do
  json.array! @discounts, partial: "discounts/discount", as: :discount
end
