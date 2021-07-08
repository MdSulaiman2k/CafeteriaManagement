class MenuItemsController < ApplicationController
  before_action :ensure_admin_in, only: %i[add create edit statusupdate update destroy]
  before_action :set_menu_item, only: %i[ edit update destroy ]
  before_action :set_cart_items, only: %i[index search]

  def index
    item = params[:item_id]
    @categorie_name = params[:category_name]
    unless (item.nil?)
      @pagy, @items = pagy(MenuItem.where("menu_category_id = ? and archived_on is NULL", item).order(:status, :id), items: 12)
    else
      @pagy, @items = pagy(MenuItem.where("archived_on is NULL").order(:status, :id), items: 12)
    end
  end

  def search
    name = params[:name]
    unless name.nil?
      @pagy, @items = pagy(MenuItem.where("archived_on is NULL and lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 12)
    end
    render "index"
  end

  def add
    @menu_categories = MenuCategory.where("archived_on is NULL")
  end

  def edit
    @menu_categories = MenuCategory.where("archived_on is NULL")
  end

  def update
    @menu_item.name = menu_item_params["name"]
    @menu_item.price = menu_item_params["price"]
    @menu_item.description = menu_item_params["description"]
    @menu_item.menu_category_id = menu_item_params[:category]
    if @menu_item.save
      flash[:success] = "Successfully Updated"
    else
      flash[:error] = @menu_item.errors.full_messages.join(", ")
    end
    redirect_to "/menu_items"
  end

  def create
    menu_item = MenuItem.new(name: params[:name], description: params[:description],
                             price: params[:price], status: "Active",
                             menu_category_id: params[:category])
    unless menu_item.save
      flash[:error] = menu_item.errors.full_messages.join(", ")
    else
      flash[:success] = "#{params[:name]} is created"
    end
    redirect_to menu_add_item_path
  end

  def statusupdate
    id = params[:id]
    status = params[:status] ? "Active" : "InActive"
    menu_item = MenuItem.find(id)
    menu_category = MenuCategory.find(menu_item.menu_category_id)
    unless menu_category.status
      flash[:error] = "First Update the menu Category status"
      redirect_back(fallback_location: "/") and return
    end
    menu_item.status = status
    menu_item.save!
    redirect_back(fallback_location: "/")
  end

  def destroy
    @menu_item.archived_on = Time.zone.now
    unless @menu_item.save
      flash[:error] = @menu_item.errors.full_messages.join(", ")
    end
    redirect_back(fallback_location: "/")
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :description, :category)
  end
end
