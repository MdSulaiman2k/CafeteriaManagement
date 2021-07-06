class OrdersController < ApplicationController
  before_action :get_order_address, only: %i[create index search]
  before_action :ensure_admin_in, :only => [:search, :update_pending_status, :search_status]

  def create
    if (params[:address].nil? and @current_user.roll != "clerk")
      flash[:error] = "Your order is not placed"
      redirect_to "/address"
    end
    @order = Order.new(address_id: params[:address], user_id: current_user.id, order_at: Time.zone.now, status: "pending")
    unless @order.save
      flash[:error] = "Your order is not placed"
      redirect_to "/address"
    else
      redirect_to shift_cart_order_path(order_id: @order.id)
    end
  end

  def search
    @search = params[:search]
    begin
      value = Integer(params[:id])
      order_at = Order.where("#{@search} = ?", value).order("delivered_at DESC NULLS FIRST", id: :desc)
    rescue
      @orders = nil
      flash[:error] = "Enter valid input"
    end
    unless (order_at.nil?)
      @orders = order_at
    end
    render "index"
  end

  def search_status
    @status_order = params[:status]
    if (@status_order == "walkin")
      @orders = Order.where("address_id is NULL").order("delivered_at DESC NULLS FIRST", id: :desc)
    else
      @orders = Order.where("status = ?", @status_order).order("delivered_at DESC NULLS FIRST", id: :desc)
    end
    render "index"
  end

  def update_pending_status
    if (@current_user.roll == "admin" || @current_user.roll == "clerk")
      order = Order.find(params[:id])
      order.delivered_at = Time.zone.now
      order.status = "delivered"
      unless order.save
        flash[:error] = order.errors.full_messages.joins(", ")
      end
      redirect_to "/orders"
    else
      redirect_to error_path
    end
  end

  def destroy
    order = Order.find(params[:id])
    if (order.status == "pending")
      order.delivered_at = Time.zone.now
      order.status = "cancel"
      unless order.save
        flash[:error] = order.errors.full_messages.joins(", ")
      else
        flash[:success] = "Order was cancel"
      end
    else
      flash[:error] = "You are not able to cancel you are order"
    end
    redirect_back(fallback_location: "/")
  end

  def index
    if @current_user.roll == "admin"
      @pagy, @orders = pagy(Order.order("delivered_at DESC NULLS FIRST", id: :desc))
    elsif @current_user.roll == "clerk"
      @pagy, @orders = pagy(Order.where("order_at >=? and order_at<=?", DateTime.now().beginning_of_month - 1.months, DateTime.now()).order("delivered_at DESC NULLS FIRST", id: :desc))
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
