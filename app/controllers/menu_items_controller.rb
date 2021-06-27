class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[ edit update destroy ]

  def index
    item = params[:item_id]
    unless (item.nil?)
      @pagy, @items = pagy(MenuItem.where(menu_category_id: item).order(:status, :id), items: 10)
    else
      @pagy, @items = pagy(MenuItem.all.order(:status, :id), items: 10)
    end
  end

  def search
    name = params[:name]
    unless name.nil?
      @pagy, @items = pagy(MenuItem.where("lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 10)
    end
    render "index"
  end

  def add
    if current_user.roll != "admin"
      redirect_to error_path
    else
      @menu_categories = MenuCategory.all
    end
  end

  def edit
    if current_user.roll != "admin"
      redirect_to error_path
    else
      [@menu_categories = MenuCategory.all, @menu_item]
    end
  end

  def update
    if current_user.roll != "admin"
      redirect_to error_path
    else
      @menu_item.name = menu_item_params["name"]
      @menu_item.price = menu_item_params["price"]
      @menu_item.description = menu_item_params["description"]
      @menu_item.menu_category_id = menu_item_params[:category]
      @menu_item.save
      redirect_to menu_items_path
    end
  end

  def create
    if current_user.roll != "admin"
      redirect_to error_path
    else
      menu_item = MenuItem.new(name: params[:name], description: params[:description],
                               price: params[:price], status: "Active",
                               menu_category_id: params[:category])
      unless menu_item.save
        flash[:error] = menu_item.errors.full_messages.join(", ")
      end
      redirect_to menu_add_item_path
    end
  end

  def statusupdate
    if current_user.roll != "admin"
      redirect_to error_path
    else
      id = params[:id]
      status = params[:status] ? "Active" : "InActive"
      menu_item = MenuItem.find(id)
      menu_item.status = status
      menu_item.save!
      redirect_to menu_items_path
    end
  end

  def destroy
    if current_user.roll != "admin"
      redirect_to error_path
    else
      @menu_item.destroy
      redirect_to menu_items_path
    end
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :description, :category)
  end
end
