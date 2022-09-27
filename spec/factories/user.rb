FactoryBot.define do
  factory :user do
    email { "testuser@test.com" }
    password { "123456" }
    role { 0 }
  end
end
