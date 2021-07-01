class MenuItem < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :status, presence: true
  has_many :cart_items, dependent: :destroy
  belongs_to :menu_category
end
