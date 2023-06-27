Rails.application.routes.draw do

  root 'movies#home'

  devise_for :users

  get '/feed', to: 'activities#feed'
  get 'watched', to: 'watched_films#watched'

  resources :users, only: [:index, :show] do
    resources :ratings, only: [:show, :destroy]
    resources :follows, only: [:create, :destroy]
    resources :watchlists, only: [:index]
    resources :watched_films, only: [:index]
    get 'following', action: :following, controller: 'follows'
    get 'followers', action: :followers, controller: 'follows'
  end

  resources :movies, only: [:index, :show]
  resources :ratings, except: [:destroy]
  resources :watchlists, only: [:index, :create, :destroy]
  resources :watched_films, only: [:index, :create, :destroy]

  resources :feedbacks, only: [:new, :create]

  match "*path", to: "application#handle_routing_error", via: :all

  get '/404', to: 'errors#not_found'


end
