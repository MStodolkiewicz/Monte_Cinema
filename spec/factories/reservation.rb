FactoryBot.define do
  factory :reservation do
    email { "test@test.com" }
    status { :reserved }
    seats { [Faker::Number.number(digits: 2)] }
    association :seance, strategy: :build
    association :user, strategy: :build
    association :discount
  end
end
