require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'class methods' do
    describe '#search' do
      it 'searches for all merchants by matching name' do
        merchant_1 = create(:merchant, name: "Bunny Hops")
        merchant_2 = create(:merchant, name: "Chapstick")
        merchant_3 = create(:merchant, name: "Shopaholics")
        merchant_4 = create(:merchant, name: "Orthopedic shoes")

        expect(Merchant.search("hop")).to eq([merchant_1, merchant_4, merchant_3])
      end
    end
  end
end