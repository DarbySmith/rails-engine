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

  it 'returns a 400 error when unit price is not number' do
    merchant_id = create(:merchant).id
    item_params = {
      name: "Barbies",
      description: "Antique toy",
      unit_price: "number",
      merchant_id: merchant_id
    }
    
    headers = { "CONTENT_TYPE" => "application/json" }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(400)
  end

  it 'returns a 400 error when there is no name' do
    merchant_id = create(:merchant).id
    item_params = {
      name: "",
      description: "Antique toy",
      unit_price: 14.58,
      merchant_id: merchant_id
    }
    
    headers = { "CONTENT_TYPE" => "application/json" }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(400)
  end

  it 'returns a 400 error when description is not present' do
    merchant_id = create(:merchant).id
    item_params = {
      name: "Barbies",
      description: "",
      unit_price: 18.44,
      merchant_id: merchant_id
    }
    
    headers = { "CONTENT_TYPE" => "application/json" }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(400)
  end

  it 'returns a 400 error when merchant does not exist' do
    item_params = {
      name: "Barbies",
      description: "Antique toy",
      unit_price: 42.56,
      merchant_id: ""
    }
    
    headers = { "CONTENT_TYPE" => "application/json" }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(400)
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

  it 'can find one item by name' do
    item = create(:item, name: "thingy")

    get "/api/v1/items/find?name=thi"

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to be_a(String)

    expect(result[:attributes]).to have_key(:description)
    expect(result[:attributes][:description]).to be_a(String)

    expect(result[:attributes]).to have_key(:unit_price)
    expect(result[:attributes][:unit_price]).to be_a(Float)

    expect(result[:attributes]).to have_key(:merchant_id)
    expect(result[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'returns the item that is alpabetically first' do
    item = create(:item, name: "thingy")
    item = create(:item, name: "chicken")

    get "/api/v1/items/find?name=hi"

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to be_a(String)

    expect(result[:attributes]).to have_key(:description)
    expect(result[:attributes][:description]).to be_a(String)

    expect(result[:attributes]).to have_key(:unit_price)
    expect(result[:attributes][:unit_price]).to be_a(Float)

    expect(result[:attributes]).to have_key(:merchant_id)
    expect(result[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'search is case insensitive and returns the item that is alpabetically first' do
    item = create(:item, name: "thingy")
    item = create(:item, name: "chicken")

    get "/api/v1/items/find?name=HI"

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to be_a(String)

    expect(result[:attributes]).to have_key(:description)
    expect(result[:attributes][:description]).to be_a(String)

    expect(result[:attributes]).to have_key(:unit_price)
    expect(result[:attributes][:unit_price]).to be_a(Float)

    expect(result[:attributes]).to have_key(:merchant_id)
    expect(result[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'can find items by minimum price' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?min_price=3"

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to be_a(String)

    expect(result[:attributes]).to have_key(:description)
    expect(result[:attributes][:description]).to be_a(String)

    expect(result[:attributes]).to have_key(:unit_price)
    expect(result[:attributes][:unit_price]).to be_a(Float)
    expect(result[:attributes][:unit_price]).to eq(4.99)

    expect(result[:attributes]).to have_key(:merchant_id)
    expect(result[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'can find an item between the min and max' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?min_price=3&max_price=5.15"

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to be_a(String)

    expect(result[:attributes]).to have_key(:description)
    expect(result[:attributes][:description]).to be_a(String)

    expect(result[:attributes]).to have_key(:unit_price)
    expect(result[:attributes][:unit_price]).to be_a(Float)
    expect(result[:attributes][:unit_price]).to eq(4.99)

    expect(result[:attributes]).to have_key(:merchant_id)
    expect(result[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'returns the item with the unit price below the max' do
    item_1 = create(:item, name: "C", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "A", unit_price: 2.75)

    get "/api/v1/items/find?max_price=5.17"

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to be_a(String)

    expect(result[:attributes]).to have_key(:description)
    expect(result[:attributes][:description]).to be_a(String)

    expect(result[:attributes]).to have_key(:unit_price)
    expect(result[:attributes][:unit_price]).to be_a(Float)
    expect(result[:attributes][:unit_price]).to eq(2.75)

    expect(result[:attributes]).to have_key(:merchant_id)
    expect(result[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'returns a 400 error if the item is not found by name' do
    get "/api/v1/items/find?name=hi"

    expect(response).to have_http_status(404)
  end
  
  it 'returns a 400 error when no items are above the min' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?min_price=6.45"

    expect(response).to have_http_status(400)
  end

  it 'returns a 400 error when no items are above the max' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?max_price=1.5"

    expect(response).to have_http_status(400)
  end

  it 'cannot send name and price together' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?name=A&max_price=5.25"

    expect(response).to have_http_status(400)
  end

  it 'returns 400 error if max is greater than min' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?min_price=5.18&max_price=3.26"

    expect(response).to have_http_status(400)
  end

 it 'returns 400 error if item is not found within the params' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?min_price=1.50&max_price=2.25"

    expect(response).to have_http_status(400)
  end

  it 'returns a 400 error if the min price is below 0' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?min_price=-1.1"

    expect(response).to have_http_status(400)
  end

  it 'returns a 400 error if the max price is below 0' do
    item_1 = create(:item, name: "A", unit_price: 4.99)
    item_2 = create(:item, name: "B", unit_price: 5.25)
    item_3 = create(:item, name: "C", unit_price: 2.75)

    get "/api/v1/items/find?max_price=-6.45"

    expect(response).to have_http_status(400)
  end
end