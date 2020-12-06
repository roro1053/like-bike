Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  resources :users, only: [:show]
  resources :items, only: [:index,:new,:create,:show] do
    resources :reviews, only: [:index,:create,:destroy]
  end
  resources :posts do
    collection do
      get 'search'
    end
    resources :comments, only: [:create,:destroy,]
  end
end
