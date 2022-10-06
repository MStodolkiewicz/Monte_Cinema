FactoryBot.define do
  factory :seance do
    start_time { DateTime.current }
    price { Faker::Number.number(digits: 2) }
    association :movie, strategy: :build
    association :hall, strategy: :build
  end
end
