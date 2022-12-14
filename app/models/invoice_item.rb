class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item

  validates_presence_of :quantity, :unit_price, :item_id, :invoice_id
end