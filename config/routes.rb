Rails.application.routes.draw do
  resources :items do
    collection do
      get 'print_barcode'
    end
  end
   
  resources :imports
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
