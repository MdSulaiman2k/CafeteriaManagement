class OrdersController < ApplicationController
  def create
    @order = Order.new(address_id: params[:address], user_id: current_user.id, order_at: Time.zone.now)

    unless @order.save
      redirect_to "/address"
    else
      redirect_to shift_cart_order_path(order_id: @order.id)
    end
  end

  def index
    @orders = @current_user.orders.order(:delivered_at)
  end
end
