require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
    it { should validate_presence_of :merchant_id }
  end

  describe 'class methods' do
    describe '#search_one_name' do
      it 'returns one items name that matches the search' do
        item = create(:item, name: "Bumble bee butter")

        expect(Item.search_one_name("butt")).to eq(item)
      end

      it 'returns the alphabetical first if multiple records are found' do
        item_1 = create(:item, name: "Sweet butter")
        item_2 = create(:item, name: "Bumble bee butter")

        expect(Item.search_one_name("butt")).to eq(item_2)
      end

      it 'returns nil if no item found' do
        expect(Item.search_one_name("butt")).to eq(nil)
      end
    end

    describe '#search_min_price' do
      it 'returns the item that has the price above the min' do
        item_1 = create(:item, unit_price: 4.99)
        item_2 = create(:item, unit_price: 2.50)

        expect(Item.search_min_price(3.14))
      end
    end

    describe '#search_max_price' do
      it 'returns the item that has the price below the max' do
        item_1 = create(:item, unit_price: 4.99)
        item_2 = create(:item, unit_price: 2.50)

        expect(Item.search_max_price(3.14)).to eq(item_2)
      end
    end

    describe '#search_price' do
      it 'returns the item that has a price between the min and max' do
        item_1 = create(:item, name: "A", unit_price: 4.99)
        item_2 = create(:item, name: "B", unit_price: 2.50)
        item_3 = create(:item, name: "C", unit_price: 4.75)
        item_4 = create(:item, name: "D", unit_price: 10.37)
        
        expect(Item.search_price(1.54, 5.26)).to eq(item_1)
      end

      it 'cannot have a min greater than max' do
        item_1 = create(:item, name: "A", unit_price: 4.99)
        item_2 = create(:item, name: "B", unit_price: 2.50)
        item_3 = create(:item, name: "C", unit_price: 4.75)
        item_4 = create(:item, name: "D", unit_price: 10.37)
        
        expect(Item.search_price(5.26, 1.54)).to eq(nil)
      end
    end
  end
end