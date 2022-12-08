class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices

  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price, greater_than: 0

  def self.search_one_name(name)
    self.order(:name).find_by("name ILIKE ?", "%#{name}%")
  end
end