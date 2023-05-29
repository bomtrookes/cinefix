Rails.application.routes.draw do
  devise_for :users

  root 'movies#home'

  resources :users, only: [:index, :show] do
    resources :ratings, only: [:destroy]
    resources :follows, only: [:create, :destroy]
    get 'following', action: :following, controller: 'follows'
    get 'followers', action: :followers, controller: 'follows'
  end
  resources :movies, only: [:index, :show]
  resources :ratings, except: [:show, :destroy]
  resources :watchlists, only: [:index, :create, :destroy]

end
