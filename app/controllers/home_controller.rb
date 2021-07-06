class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    if current_user
      if current_user.roll == "admin"
        redirect_to order_invoice_path and return
      elsif current_user.roll == "clerk"
        redirect_to "/orders"
      else
        redirect_to menu_category_index_path
      end
    else
      render "index"
    end
  end
end
