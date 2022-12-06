require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of all merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'can get merchant by its id' do
    id = create(:merchant).id
    
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)    
  end
end