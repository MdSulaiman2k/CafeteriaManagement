Rails.application.routes.draw do
  get "/menu_category/search" => "menu_category#search", as: :search_menu_category
  get "/menu_items/search" => "menu_items#search", as: :search_menu_item
  get "/menu_items/addItem" => "menu_items#add", as: :menu_add_item
  resources :menu_category
  resources :menu_items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
