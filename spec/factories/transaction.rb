FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Number.number(digits: 16) }
    credit_card_expiration_date { Faker::Date.between(from '2024/01/01', to: '2030/01/01').strftime("%m/%y") }
    invoice_id { Faker::Numer.within_range(1..4845) }
    result { Faker::Random.array(['success', 'failed'])}
  end
end