class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :menu_item, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :menu_item_name, null: false
      t.decimal :menu_item_price, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
