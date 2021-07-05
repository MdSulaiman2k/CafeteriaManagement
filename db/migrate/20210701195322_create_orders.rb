class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, foreign_key: true
      t.string :status, null: false
      t.datetime :order_at, null: false
      t.datetime :delivered_at
    end
  end
end
