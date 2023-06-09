Rails.application.routes.draw do
  devise_scope :user do  
    post 'api/v1/login', to: 'users/sessions#create'
    get 'api/v1/logout', to: 'users/sessions#destroy'  
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

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
    get 'articles/:id/comments', to: 'comments#index', as: 'admin_article_comments'
    get 'articles/:id/generate_pdf', to: 'articles#generate_pdf', as: 'generate_pdf'   
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html  
end
