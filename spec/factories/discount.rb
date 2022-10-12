FactoryBot.define do
  factory :discount do
    tickets_needed { Faker::Number.number(digits: 1) }
    value { Faker::Number.number(digits: 2) }
  end
end
