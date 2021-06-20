class MenuItem < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :status, presence: true

  belongs_to :menu_category
end
