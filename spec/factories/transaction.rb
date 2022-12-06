FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Number.number(digits: 16) }
    credit_card_expiration_date { Faker::Date.between(from '2024/01/01', to: '2030/01/01').strftime("%m/%y") }
    invoice
    result { Faker::Random.array(['success', 'failed'])}
  end
end