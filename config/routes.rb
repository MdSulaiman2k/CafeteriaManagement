Rails.application.routes.draw do
  get "invoice/index"
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
  patch "/cart_items/quantity" => "cart_items#updatequantity", as: :cart_quantity_update
  get "/order_items/shiftcart" => "order_items#shift_cart_to_order", as: :shift_cart_order
  patch "/updatestatus" => "orders#update_pending_status", as: :update_pending_status
  get "/search" => "orders#search", as: :search_orders
  get "/menu_items/recycle" => "recycle#menu_items_recycle"
  get "/restoremenuitem/:id" => "recycle#restore_menu_items", as: :restore_menu_item
  get "/menu_items/recycle/search" => "recycle#search", as: :search_recycle_menu_item
  delete "/deletemenuitem/:id" => "recycle#delete_menu_item", as: :delete_menu_item
  get "/menu_category/recycle" => "recycle#menu_category_recycle"
  get "/restoremenucategory/:id" => "recycle#restore_menu_category", as: :restore_menu_category
  get "/menu_category/recycle/search" => "recycle#search_menucategory", as: :search_recycle_menu_categories
  delete "/deletemenucategory/:id" => "recycle#delete_menu_category", as: :delete_menu_category
  get "orders/invoice" => "invoice#index", as: :order_invoice
  get "orders/status" => "orders#search_status", as: :search_order_status
  get "orders/timeduration" => "orders#search_time_duration", as: :search_time_duration
  get "users/recycle" => "recycle#user_recycle"
  get "/users/recycle/search" => "recycle#search_users", as: :search_recycle_users
  get "/restore_user/:id" => "recycle#restore_user", as: :restore_recycle_users
  resources :users
  resources :menu_category
  resources :menu_items
  resources :address
  resources :cart_items
  resources :orders
  resources :order_items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
