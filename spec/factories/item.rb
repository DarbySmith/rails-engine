FactoryBot.define do
  factory :item do
    item { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant_id { Faker::Numer.within_range(1..100) }
  end
end