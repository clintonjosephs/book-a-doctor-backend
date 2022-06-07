FactoryBot.define do
  factory :doctor do
    name { Faker::Name.name }
    city { Faker::Address.city }
    specialization { Faker::Job.field }
    cost_per_day { Faker::Number.number(digits: 2) }
    description { Faker::Lorem.paragraph }
  end
end
