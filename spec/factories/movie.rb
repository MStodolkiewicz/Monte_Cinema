FactoryBot.define do
  factory :movie do
    name { Faker::Movie.title }
    description { Faker::Movie.quote }
    duration { 125 }
  end
end
