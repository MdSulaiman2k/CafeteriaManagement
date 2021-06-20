class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[ edit update destroy ]

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
    unless name.nil?
      @pagy, @items = pagy(MenuItem.where("lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 6)
    end
    render "index"
  end

  def add
    @menu_categories = MenuCategory.all
  end

  def edit
    [@menu_categories = MenuCategory.all, @menu_item]
  end

  def update
    @menu_item.name = menu_item_params["name"]
    @menu_item.price = menu_item_params["price"]
    @menu_item.description = menu_item_params["description"]
    @menu_item.menu_category_id = menu_item_params[:category]
    @menu_item.save
    redirect_to menu_items_path
  end

  def create
    menu_item = MenuItem.new(name: params[:name], description: params[:description], price: params[:price], status: "Active", menu_category_id: params[:category])
    unless menu_item.save
      flash[:error] = menu_item.errors.full_messages.join(", ")
    end
    redirect_to menu_add_item_path
  end

  def statusupdate
    id = params[:id]
    status = params[:status] ? "Active" : "InActive"
    menu_item = MenuItem.find(id)
    menu_item.status = status
    menu_item.save!
    redirect_to menu_items_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :description, :category)
  end
end
