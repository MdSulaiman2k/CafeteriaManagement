class CartItem < ApplicationRecord
  belongs_to :menu_items
  belongs_to :carts
end
