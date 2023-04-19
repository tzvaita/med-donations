Rails.application.routes.draw do
  get 'pages/index'
  resources :owners
  resources :payments
  get 'payments/create'
  resources :orders
  resources :requests
  resources :donations
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "pages#index"
end
