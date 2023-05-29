Rails.application.routes.draw do
  devise_for :users

  root 'movies#home'

  resources :users, only: [:index, :show] do
    resources :follows, only: [:create, :destroy]
    get 'following', on: :member
    get 'followers', on: :member
  end
  resources :movies, only: [:index, :show]
  resources :ratings, except: [:show, :destroy]
  resources :watchlists, only: [:index, :create, :destroy]

end
