Rails.application.routes.draw do
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
   
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "items#index"
end
