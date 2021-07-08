class OrderItemsController < ApplicationController
  before_action :get_order_address, only: %i[index]
  before_action :ensure_user_in, only: %i[shift_cart_to_order]

  def shift_cart_to_order
    checkerror = false
    ordertotal = 0
    CartItem.all.each do |cart|
      orderitem = OrderItem.new(order_id: params[:order_id], menu_item_id: cart.menu_item_id, menu_item_name: cart.menu_item_name,
                                menu_item_price: cart.menu_item_price, quantity: cart.quantity)
      ordertotal += cart.menu_item_price * cart.quantity
      unless (orderitem.save)
        flash[:error] = order.errors.full_messages.join(", ")
        checkerror = true
      end
    end
    unless checkerror
      new_order = Order.find(params[:order_id])
      new_order.totalvalue = ordertotal
      new_order.save!
      flash[:success] = "Your orders is placed"
    end
    @current_user.cart_items.destroy_all
    redirect_to menu_items_path
  end

  def index
    if (current_user.roll == "admin" || current_user.roll == "clerk")
      @orderitems = User.find(params[:user_id]).orders.find(params[:order_id]).order_items.order(:id)
    else
      @orderitems = current_user.orders.find(params[:order_id]).order_items.order(:id)
    end
  end

  def get_order_address
    @order = Order.find(params[:order_id])
    @user = User.find(@order.user_id)
    unless @order.address_id.nil?
      @address = @user.addresses.find(@order.address_id)
    end
  end
end
