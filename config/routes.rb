Rails.application.routes.draw do
  devise_for :users
  #resources :items do
  #  collection do
  #   get 'print_barcode'
    #end
 # end

 resources :items do
  member do
    get 'print_barcode'
  end
 end

 resources :items do
  collection do
    post :import
  end
end

get 'del_all', to: 'items#del_all'
get 'print_all', to: 'items#print_all'
   
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "items#index"
end
