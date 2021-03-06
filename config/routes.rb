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
  resources :users do
    member do
      get 'item'
      get 'like'
      get :following, :followers
    end
  end
  resources :follow_relationships, only: [:create, :destroy]
  resources :items do
    collection do
      get 'search'
    end
    collection do
      get 'locate'
    end
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
