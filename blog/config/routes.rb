Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end
  # Defines the root path route ("/")
  root "articles#index"

  resources :articles do
    resources :comments
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html  
end
