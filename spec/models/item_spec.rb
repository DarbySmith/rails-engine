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
  end
end