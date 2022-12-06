FactoryBot.define do
  factory :invoice do
    customer_id { Faker::Number.within_range(1..1000) }
    merchant_id { Faker::Number.within_range(1..100)}
    status { Faker::Random.array(['shipped', 'packaged', 'returned'])}
  end
end