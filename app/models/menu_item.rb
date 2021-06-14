class MenuItem < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :price
  belongs_to :menu_category
end
