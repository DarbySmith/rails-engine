FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.within_range(1..20) }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    item_id { Faker::Number.within_range(1..2500)}
    invoice_id { Faker::Number.within_range(4..4845)}
  end
end
