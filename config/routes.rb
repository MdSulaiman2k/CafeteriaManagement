Rails.application.routes.draw do
  get "/" => "home#index"
  get "/menu_category/search" => "menu_category#search", as: :search_menu_category
  get "/menu_items/search" => "menu_items#search", as: :search_menu_item
  get "/users/search" => "users#search", as: :search_users
  get "/menu_items/addItem" => "menu_items#add", as: :menu_add_item
  put "/menu_category/update/:id" => "menu_category#statusupdate"
  put "/menu_items/update/:id" => "menu_items#statusupdate"
  get "/signin" => "session#new", as: :new_sessions
  get "/error" => "error#error", as: :error
  post "/signin" => "session#create", as: :sessions
  delete "/signout" => "session#destroy", as: :destroy_session
  patch "/roll/:id" => "users#updateroll"
  patch "/address/editdefault/:id" => "address#set_default", as: :edit_defaultaddress
  resources :users
  resources :menu_category
  resources :menu_items
  resources :address
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
