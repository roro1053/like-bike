Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
   }
  devise_scope :user do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy" 
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
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
    resource :likes, only: [:create, :destroy]
    resources :reviews, only: [:index,:create,:destroy]
  end
  resources :posts do
    resource :likes, only: [:create, :destroy]
    collection do
      get 'search'
    end
    resources :comments, only: [:create,:destroy,]
  end
end
