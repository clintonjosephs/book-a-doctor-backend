FactoryBot.define do
  factory :appointment do
    date_of_appointment { '2022-06-01' }
    user { nil }
    doctor { nil }
  end
end
