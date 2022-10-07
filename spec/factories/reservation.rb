FactoryBot.define do
  factory :reservation do
    email { "test@test.com" }
    status { :reserved }
    association :seance, strategy: :build
    association :user, strategy: :build
  end
end
