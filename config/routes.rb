Rails.application.routes.draw do

  root 'movies#home'

  devise_for :users
  # devise_for :users, controllers: { registrations: "registrations" }

  resources :users, only: [:index, :show] do
    resources :ratings, only: [:destroy]
    resources :follows, only: [:create, :destroy]
    get 'following', action: :following, controller: 'follows'
    get 'followers', action: :followers, controller: 'follows'
  end
  resources :movies, only: [:index, :show]
  resources :ratings, except: [:show, :destroy]
  resources :watchlists, only: [:index, :create, :destroy]

  match "*path", to: "application#handle_routing_error", via: :all


end
