require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of all merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get merchant by its id' do
    id = create(:merchant).id
    
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)    
  end

  it 'returns a 400 error when the merchant does not exist' do
    get "/api/v1/merchants/1"

    expect(response).to have_http_status(404)
  end

  it 'can find all merchants with name match' do
    merchant_1 = create(:merchant, name: "Bunny Hops")
    merchant_2 = create(:merchant, name: "Chapstick")
    merchant_3 = create(:merchant, name: "Shopaholics")
    merchant_3 = create(:merchant, name: "Orthopedic shoes")

    get '/api/v1/merchants/find_all?name=hop'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String) 
    end
  end
end