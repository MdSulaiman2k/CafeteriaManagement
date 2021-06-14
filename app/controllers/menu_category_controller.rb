class MenuCategoryController < ApplicationController
  before_action :set_menu_category, only: %i[ show edit update destroy ]

  def index
    @pagy, @categories = pagy(MenuCategory.all.order(:id), items: 3)
  end

  def search
    name = params[:name]
    unless name.nil?
      @pagy, @categories = pagy(MenuCategory.where("lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 3)
    else
      @pagy, @categories = pagy(MenuCategory.all.order(:id), items: 3)
    end
    render "index"
  end

  def create
    name = params[:name]
    @menu_category = MenuCategory.new(name: name)
    unless @menu_category.save
      flash[:error] = @menu_category.errors.full_messages.join(", ")
    end
    redirect_to menu_category_index_path
  end

  def edit
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
