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
        description:  Faker::Movie.quote,
        duration: rand(100) + 90
    )
end

500.times do
    Seance.create(
        movie_id: rand(10) + 1,
        hall_id: rand(10) + 1,
        start_time: rand(14).days.from_now + rand(24).hours + rand(60).minutes,
        price: rand(10) + 15
    )
end
