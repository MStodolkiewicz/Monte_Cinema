Hall.create(name: 'Hall 1', capacity: 20)
Hall.create(name: 'Hall 2', capacity: 50)
Hall.create(name: 'Hall 3', capacity: 50)
Hall.create(name: 'Hall 4', capacity: 50)
Hall.create(name: 'Hall 5', capacity: 50)
Hall.create(name: 'Hall 6', capacity: 100)
Hall.create(name: 'Hall 7', capacity: 100)
Hall.create(name: 'Hall 8', capacity: 100)
Hall.create(name: 'Hall 9', capacity: 100)
Hall.create(name: 'Hall 10', capacity: 200)

10.times do
  Movie.create(
    name: Faker::Movie.title,
    description: Faker::Movie.quote,
    duration: rand(90..189)
  )
end

500.times do
  Seance.create(
    movie_id: Movie.all.sample.id,
    hall_id: Hall.all.sample.id,
    start_time: DateTime.current.beginning_of_minute + rand(14).days + rand(24).hours + rand(60).minutes,
    price: rand(15..24)
  )
end

(1..5).each do |tickets_needed|
  Discount.create(
    tickets_needed: tickets_needed * 2,
    value: tickets_needed * 5
  )
end
