class AddCommentToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :comment, :string
  end
end
