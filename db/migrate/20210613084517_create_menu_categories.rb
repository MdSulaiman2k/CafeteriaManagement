class CreateMenuCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.boolean :status, null: false
      t.datetime :archived_on
      t.timestamps
    end
  end
end
