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

  def self.search_min_price(min)
    self.order(:name)
      .find_by("unit_price >= #{min}")
  end

  def self.search_max_price(max)
    self.order(:name)
      .find_by("unit_price <= #{max}")
  end

  def self.search_price(min, max)
    if min > max
      nil
    else
      self.order(:name)
      .find_by("unit_price >= #{min} AND unit_price <= #{max}")
    end
  end
end