FactoryBot.define do
  factory :hall do
    capacity { Faker::Number.number(digits: 2) }
    name { "Sala #{Faker::Number.number(digits: 3)}" }
  end
end
