Rails.application.routes.draw do
  devise_for :users

  root 'movies#home'

  resources :users, only: [:index, :show]
  resources :movies, only: [:index, :show]
  resources :ratings, only: [:index, :new, :create]
  resources :watchlists, only: [:index, :create, :destroy]

end
