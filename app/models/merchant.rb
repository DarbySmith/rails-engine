class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.search(name)
    self.order(:name)
      .where("name ILIKE ?", "%#{name}%")
  end
end