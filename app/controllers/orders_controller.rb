class OrdersController < ApplicationController
  before_action :get_order_address, only: %i[create index]
  before_action :ensure_admin_in, :only => [:search]

  def create
    @order = Order.new(address_id: params[:address], user_id: current_user.id, order_at: Time.zone.now)
    unless @order.save
      flash[:erro] = "Your order is not placed"
      redirect_to "/address"
    else
      redirect_to shift_cart_order_path(order_id: @order.id)
    end
  end

  def search
    user = User.find_by(id: params[:id])
    unless (user.nil?)
      @pagy, @orders = pagy(user.orders.order("delivered_at DESC NULLS FIRST"))
    end
    render "index"
  end

  def update_pending_status
    if (@current_user.roll == "admin" || @current_user.roll == "clerk")
      order = Order.find(params[:id])
      order.delivered_at = Time.zone.now
      unless order.save
        flash[:error] = order.errors.full_messages.joins(", ")
      end
      redirect_to "/orders"
    else
      redirect_to error_path
    end
  end

  def index
    if @current_user.roll == "admin"
      @pagy, @orders = pagy(Order.order("delivered_at DESC NULLS FIRST", id: :desc))
    elsif @current_user.roll == "clerk"
      @pagy, @orders = pagy(Order.where("user_id = ? or delivered_at is NULL", current_user.id).order("delivered_at DESC NULLS FIRST", id: :desc))
    else
      @pagy, @orders = pagy(@current_user.orders.order("delivered_at DESC NULLS FIRST", id: :desc))
    end
  end

  def show
    @order = @current_user.order.find(params[:id])
  end

  private

  def get_order_address
    @addresses = @current_user.addresses
  end
end
