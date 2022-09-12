json.extract! seance, :id, :start_time, :end_time, :price, :hall_id, :movie_id, :created_at, :updated_at
json.url seance_url(seance, format: :json)
