class MenuCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, :uniqueness => true
end
