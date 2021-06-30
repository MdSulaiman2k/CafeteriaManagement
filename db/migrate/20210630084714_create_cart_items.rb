class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items do |t|
      t.string :menu_items_name
      t.string :menu_items_price
      t.references :menu_items, null: false, foreign_key: true
      t.references :carts, null: false, foreign_key: true

      t.timestamps
    end
  end
end
