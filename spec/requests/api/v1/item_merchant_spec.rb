require 'rails_helper'

RSpec.describe "Item merchant API endpoint" do
  it 'return the merchants information for that item id' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end