require 'rails_helper'

RSpec.describe 'Items API' do
  it 'returns a list of items' do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful
    
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

  it 'returns an item based on given id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful
    
    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'returns a 400 error when an item id does not exist' do
    get "/api/v1/items/1"

    expect(response).to have_http_status(404)
  end

  it 'can create a new item' do
    merchant_id = create(:merchant).id
    item_params = {
      name: "Barbies",
      description: "Antique toy",
      unit_price: 241.12,
      merchant_id: merchant_id
    }
    
    headers = { "CONTENT_TYPE" => "application/json" }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it 'can update an item' do
    item = create(:item)
    previous_name = Item.last.name
    item_params = { "name": "Ken" }

    headers = { "CONTENT_TYPE" => "application/json" }
    
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    item = Item.find(item.id)
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Ken")
  end

  it 'returns a 400 error when an item unit price is invalid' do
    item = create(:item)
    previous_name = Item.last.name
    item_params = { unit_price: "high" }

    headers = { "CONTENT_TYPE" => "application/json" }
    
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(404)
  end

  it 'returns a 400 error when item to update does not exist' do
    item_params = { "name": "Ken" }

    headers = { "CONTENT_TYPE" => "application/json" }
    
    patch "/api/v1/items/1", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(404)
  end

  it 'can destroy and item' do
    item = create(:item)
    
    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end