class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items do |t|
      t.string :menu_item_name, null: false
      t.decimal :menu_item_price, null: false
      t.integer :quantity, null: false
      t.references :menu_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
