class RecycleController < ApplicationController
  before_action :ensure_admin_in
  before_action :set_menu_item, only: %i[ restore_menu_items delete_menu_item ]
  before_action :set_menu_cetegory, only: %i[ restore_menu_category delete_menu_category ]

  def menu_items_recycle
    @pagy, @menuItems = pagy(MenuItem.where("archived_on is not NULL"))
    render "index"
  end

  def user_recycle
    @pagy, @users = pagy(User.where("archived_on is not NULL"))
    render "user-index"
  end

  def search_users
    name = params[:name]
    @search_category = params[:search]
    if ((@search_category == "id"))
      begin
        id = Integer(name)
        @pagy, @users = pagy(User.where("id = ? and archived_on is not NULL", name))
      rescue
        flash[:error] = "Enter valid input"
      end
    else
      @pagy, @users = pagy(User.where("lower(#{@search_category})  Like '" + "#{name.downcase}%' and archived_on is not NULL").order(:name, :id), items: 10)
    end
    render "user-index"
  end

  def restore_user
    user = User.find(params[:id])
    user.archived_on = nil
    unless user.save(validate: false)
      flash[:error] = user.errors.full_messages.join(", ")
    end
    redirect_back(fallback_location: "/")
  end

  def menu_category_recycle
    @pagy, @menucategories = pagy(MenuCategory.where("archived_on is not NULL"))
    render "category-index"
  end

  def search_menucategory
    name = params[:name]
    unless name.nil?
      @pagy, @menucategories = pagy(MenuCategory.where("archived_on is not NULL and lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 12)
    end
    render "category-index"
  end

  def search
    name = params[:name]
    unless name.nil?
      @pagy, @menuItems = pagy(MenuItem.where("archived_on is not NULL and lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 12)
    end
    render "index"
  end

  def restore_menu_category
    @menucategory.archived_on = nil
    unless @menucategory.save
      flash[:error] = @menucategory.errors.full_messages.join(", ")
    else
      flash[:success] = "Restored your menu Category"
    end
    redirect_back(fallback_location: "/")
  end

  def delete_menu_category
    unless (@menucategory.archived_on.nil?)
      menuItemcount = MenuItem.where("menu_category_id = ?  and archived_on is NULL", params[:id]).count
      if menuItemcount == 0
        menucategory = MenuCategory.where(archived_on: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, id: params[:id])
        if (menucategory.empty?)
          if @menucategory.destroy
            flash[:success] = "Successfully Deleted Your menu Category"
          else
            flash[:error] = @menucategory.errors.full_messages.join(", ")
          end
        else
          flash[:error] = "Today You can't delete the menu category"
        end
      else
        flash[:error] = "Not allowed first delete all the menu Items"
      end
    end
    redirect_back(fallback_location: "/")
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
      else
        flash[:success] = "Restored your menu items"
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

  def set_menu_cetegory
    @menucategory = MenuCategory.find(params[:id])
  end
end
