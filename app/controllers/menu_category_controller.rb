class MenuCategoryController < ApplicationController
  before_action :ensure_admin_in, only: %i[create edit statusupdate update destroy]
  before_action :set_menu_category, only: %i[ show edit update destroy ]
  before_action :set_cart_items, only: %i[index search]

  def index
    @pagy, @categories = pagy(MenuCategory.all.order(:status => :desc, :id => :asc), items: 10)
  end

  def search
    name = params[:name]
    unless name.nil?
      @pagy, @categories = pagy(MenuCategory.where("lower(name)  Like '" + "#{name.downcase}%'").order(:status => :desc, :id => :asc), items: 10)
    else
      @pagy, @categories = pagy(MenuCategory.all.order(:status => :desc, :id => :asc), items: 10)
    end
    render "index"
  end

  def create
    name = params[:name]
    @menu_category = MenuCategory.new(name: name, status: true)
    unless @menu_category.save
      flash[:error] = @menu_category.errors.full_messages.join(", ")
    end
    redirect_to menu_category_index_path
  end

  def edit
  end

  def statusupdate
    id = params[:id]
    status = params[:status] ? true : false
    menu_category = MenuCategory.find(id)
    menu_category.status = status
    menu_category.save!
    redirect_to menu_category_index_path
  end

  def update
    @menu_category.name = menu_category_params["name"]
    @menu_category.save
    redirect_to menu_category_index_path
  end

  def destroy
    @menu_category.destroy
    redirect_to menu_category_index_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu_category
    @menu_category = MenuCategory.find(params[:id])
  end

  def menu_category_params
    params.require(:menu_category).permit(:name)
  end
end
