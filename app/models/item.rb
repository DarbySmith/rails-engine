class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices

  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price, greater_than: 0

  after_destroy :destroy_invoices

  private
    def destroy_invoices
      if self.destroyed?

      end
      require 'pry'; binding.pry
    end
end