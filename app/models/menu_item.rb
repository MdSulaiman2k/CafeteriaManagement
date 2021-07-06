class MenuItem < ApplicationRecord
  validates :name, :uniqueness => { :case_sensitive => false }
  validates :description, presence: true
  validates :price, presence: true
  validates :status, presence: true
  has_many :cart_items, dependent: :destroy
  belongs_to :menu_category
  validates :price, numericality: { greater_than: 0 }
end
