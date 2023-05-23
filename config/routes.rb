Rails.application.routes.draw do
  devise_for :users

  root 'movies#index'

  resources :movies, only: [:index, :show]
  resources :ratings, only: [:index, :new, :create]
  resources :watchlists, only: [:index, :new, :create]

end
