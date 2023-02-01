Rails.application.routes.draw do
  resources :items do
    post :import, on: :member
  end
  resources :imports
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
