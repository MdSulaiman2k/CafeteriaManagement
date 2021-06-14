class MenuCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, :uniqueness => true
  has_many :menu_items, dependent: :destroy
end
