class OrdersController < ApplicationController
  before_action :get_order_address, only: %i[create index search]
  before_action :ensure_admin_in, :only => [:search, :search_status]
  before_action :ensure_user_in, only: %i[create]

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
      @pagy, @orders = pagy(Order.where("#{@search} = ?", value).order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    rescue
      @orders = nil
      flash[:error] = "Enter valid input"
    end
    render "index"
  end

  def search_status
    @status_order = params[:status]
    if (@status_order == "walkin")
      @pagy, @orders = pagy(Order.where("address_id is NULL").order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    else
      @pagy, @orders = pagy(Order.where("status = ?", @status_order).order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    end
    render "index"
  end

  def search_time_duration
    if current_user.roll == "admin" || current_user.roll == "clerk"
      @pagy, @orders = pagy(Order.where("order_at >= '#{params[:from].in_time_zone("Asia/Kolkata")}' AND order_at <= '#{params[:to].in_time_zone("Asia/Kolkata").end_of_day}'").
        order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    else
      @pagy, @orders = pagy(current_user.orders.where("order_at >= '#{params[:from].in_time_zone("Asia/Kolkata")}' AND order_at <= '#{params[:to].in_time_zone("Asia/Kolkata").end_of_day}'").
        order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    end
    render "index"
  end

  def update_pending_status
    if (@current_user.roll == "admin" || @current_user.roll == "clerk")
      order = Order.find(params[:id])
      order.delivered_at = Time.zone.now
      order.status = "delivered"
      order.comment = params[:reason]
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
      order.comment = params[:reason]
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
      @pagy, @orders = pagy(Order.order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    elsif @current_user.roll == "clerk"
      @pagy, @orders = pagy(Order.where("order_at >=? and order_at<=?", DateTime.now().beginning_of_month - 1.months, DateTime.now()).order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    else
      @pagy, @orders = pagy(@current_user.orders.order("delivered_at DESC NULLS FIRST", id: :desc), items: 10)
    end
  end

  def show
    @order = @current_user.orders.find(params[:id])
  end

  private

  def get_order_address
    @addresses = @current_user.addresses
  end
end
