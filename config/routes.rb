Rails.application.routes.draw do
  get "/menu_category/search" => "menu_category#search", as: :search_menu_category
  resources :menu_category
  resources :menu_items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
