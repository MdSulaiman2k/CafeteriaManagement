class MenuItemsController < ApplicationController
  def index
    item = params[:item_id]
    unless (item.nil?)
      @pagy, @items = pagy(MenuItem.where(menu_category_id: item).order(:id), items: 6)
    else
      @pagy, @items = pagy(MenuItem.all.order(:id), items: 6)
    end
  end

  def search
    name = params[:name]
    puts "\n\n\n#{params[:item_id]}v\n\n\n"
    unless name.nil?
      @pagy, @items = pagy(MenuItem.where("lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 6)
    end
    render "index"
  end
end
