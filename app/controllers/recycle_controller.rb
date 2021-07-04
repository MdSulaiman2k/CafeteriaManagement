class RecycleController < ApplicationController
  before_action :ensure_admin_in
  before_action :set_menu_item, only: %i[ restore_menu_items delete_menu_item ]

  def menu_items_recycle
    @pagy, @menuItems = pagy(MenuItem.where("archived_on is not NULL"))
    render "index"
  end

  def search
    name = params[:name]
    unless name.nil?
      @pagy, @items = pagy(MenuItem.where("archived_on is not NULL and lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 12)
    end
    render "index"
  end

  def restore_menu_items
    menu_item_id = params[:id]
    menu_category = MenuCategory.where("archived_on is not NULL and id = ?", @menu_item.menu_category_id)
    unless menu_category.empty?
      flash[:error] = "First Restore the Menu Category"
    else
      @menu_item.archived_on = nil
      unless @menu_item.save
        flash[:error] = @menu_item.errors.full_messages.join(", ")
      end
    end
    redirect_back(fallback_location: "/")
  end

  def delete_menu_item
    unless (@menu_item.archived_on.nil?)
      menuitem = MenuItem.where(archived_on: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, id: params[:id])
      if (menuitem.empty?)
        if @menu_item.destroy
          flash[:success] = "Successfully Deleted Your menu Items"
        else
          flash[:error] = @menu_item.errors.full_messages.join(", ")
        end
      else
        flash[:error] = "Today You can't delete the menu Item"
      end
    end
    redirect_back(fallback_location: "/")
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end
end
