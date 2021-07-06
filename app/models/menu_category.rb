class MenuCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, :uniqueness => { :case_sensitive => false }
  has_many :menu_items
end
