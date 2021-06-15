class CreateMenuItems < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, null: false
      t.string :status, null: false
      t.references :menu_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
