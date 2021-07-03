class CartItemsController < ApplicationController
  def index
  end

  def create
    value = params[:value].to_i
    if (value == 0)
      menuitem = MenuItem.find(params[:item_id])
      @cart_item = CartItem.new(menu_item_name: menuitem.name, menu_item_price: menuitem.price,
                                menu_item_id: menuitem.id, quantity: 1, user_id: current_user.id)
    else
      @cart_item = CartItem.where("menu_item_id = ? and user_id= ?", params[:item_id], @current_user.id).first
      @cart_item.quantity = value + 1
    end
    unless @cart_item.save
      flash[:error] = @cart_item.errors.full_messages.join(", ")
    end
    redirect_back(fallback_location: "/")
  end

  def updatequantity
    value = params[:value].to_i
    if (value == 0)
      redirect_back(fallback_location: "/")
    else
      cart_item = CartItem.where("menu_item_id = ? and user_id= ?", params[:item_id], current_user.id).first
      value -= 1
      if (cart_item)
        if (value == 0)
          cart_item.destroy
        else
          cart_item.quantity = value
          unless cart_item.save
            flash[:error] = cart_item.errors.full_messages.join(", ")
          end
        end
      end
      redirect_back(fallback_location: "/")
    end
  end
end
