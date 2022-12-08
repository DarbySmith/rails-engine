FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { Faker::Base.sample(['shipped', 'packaged', 'returned'])}
  end
end