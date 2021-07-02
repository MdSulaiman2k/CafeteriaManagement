class OrderItemsController < ApplicationController
  def shift_cart_to_order
    CartItem.all.each do |cart|
      orderitem = OrderItem.new(order_id: params[:order_id], menu_item_id: cart.menu_item_id, menu_item_name: cart.menu_item_name,
                                menu_item_price: cart.menu_item_price, quantity: cart.quantity)
      unless (orderitem.save)
        flash[:error] = order.errors.full_messages.join(", ")
      end
    end
    @current_user.cart_items.destroy_all
    redirect_to menu_items_path
  end

  def index
    @orderitems = @current_user.orders.order_items
  end
end
