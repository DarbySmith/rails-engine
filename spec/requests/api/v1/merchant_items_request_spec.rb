require 'rails_helper' 

RSpec.describe "Merchant items API" do
  it 'returns all items for a merchant' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 5, merchant_id: merchant_1.id)
    create_list(:item, 3, merchant_id: merchant_2.id)

    get "/api/v1/merchants/#{merchant_1.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(5)

    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end
end