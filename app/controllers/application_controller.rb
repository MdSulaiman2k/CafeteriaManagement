class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :ensure_user_logged_in

  def ensure_user_logged_in
    unless current_user
      redirect_to "/"
    end
  end

  def current_user
    return @current_user if @current_user

    current_user_id = session[:current_user_id]
    if current_user_id
      @current_user = User.where("id = ? and archived_on is NULL", current_user_id).first
    else
      nil
    end
  end

  def ensure_admin_in
    unless current_user.roll == "admin"
      redirect_to error_path
    end
  end

  def set_cart_items
    @cartitems = CartItem.where("user_id = ? ", current_user.id)
    @totalamount = 0
    @cartitems.each do |item|
      @totalamount += item.menu_item_price * item.quantity
    end
  end
end
