class OrderItemsController < ApplicationController
  def shift_cart_to_order
    checkerror = false
    CartItem.all.each do |cart|
      orderitem = OrderItem.new(order_id: params[:order_id], menu_item_id: cart.menu_item_id, menu_item_name: cart.menu_item_name,
                                menu_item_price: cart.menu_item_price, quantity: cart.quantity)
      unless (orderitem.save)
        flash[:error] = order.errors.full_messages.join(", ")
        checkerror = true
      end
    end
    unless checkerror
      flash[:success] = "Your orders is placed"
    end
    @current_user.cart_items.destroy_all
    redirect_to menu_items_path
  end

  def index
    @pagy, @orderitems = pagy(User.find(params[:user_id]).orders.find(params[:order_id]).order_items.order(:id))
  end
end
