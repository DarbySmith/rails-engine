FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { Faker::Random.array(['shipped', 'packaged', 'returned'])}
  end
end