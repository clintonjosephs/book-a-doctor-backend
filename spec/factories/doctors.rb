FactoryBot.define do
  factory :doctor do
    name { "MyString" }
    city { "MyString" }
    specialization { "MyString" }
    cost_per_day { 1 }
    description { "MyText" }
  end
end
