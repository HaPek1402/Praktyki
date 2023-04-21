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
  get '/admin', to: redirect('/admin/articles')
  namespace :admin do
    resources :articles do
      resources :comments
      get 'new', to: 'articles#new', as: 'new'
    end
    
    get 'articles/:id', to: 'articles#show', as: 'admin_article'
    get 'articles/:id/comments', to: 'comments#index', as: 'article_comments'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html  
end
