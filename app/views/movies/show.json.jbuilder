json.movie do
  json.partial! "movies/movie", movie: @movie

  json.seances do
    json.array! @seances, partial: "seances/seance", as: :seance
  end
end
