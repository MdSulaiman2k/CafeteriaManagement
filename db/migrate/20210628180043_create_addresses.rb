class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :name, null: false
      t.string :street, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :postal_code, null: false
      t.string :phonenumber, null: false
      t.boolean :defaultaddress, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
