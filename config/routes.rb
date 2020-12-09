Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  resources :users, only: [:show] do
    member do
      get 'item'
    end
  end
  resources :items, only: [:index,:new,:create,:show,:destroy] do
    collection do
      get 'search'
    end
    collection do
      get 'locate'
    end
    resources :reviews, only: [:index,:create,:destroy]
  end
  resources :posts do
    collection do
      get 'search'
    end
    resources :comments, only: [:create,:destroy,]
  end
end
