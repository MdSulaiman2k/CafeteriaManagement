class MenuItemsController < ApplicationController
  def index
    item = params[:item_id]
    unless (item.nil?)
      @pagy, @items = pagy(MenuItem.where(menu_category_id: params[:item_id]).order(:id), items: 6)
    end
    @pagy, @items = pagy(MenuItem.all.order(:id), items: 6)
  end
end
