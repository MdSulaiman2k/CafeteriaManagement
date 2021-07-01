class OrdersController < ApplicationController
  def create
    @order = Order.new(address_id: params[:address], user_id: current_user.id)
    @order.save
    redirect_to menu_items_path
  end
end
