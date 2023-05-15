Rails.application.routes.draw do
  devise_for :users

  root 'movies#index'

  resources :users do
    resources :ratings, only: [:index]
    resources :movie_ratings, only: [:index]
  end

  resources :movies, only: [:index, :show] do
    resources :ratings, only: [:index, :new, :create]
  end

  resources :ratings, only: [:index, :new, :create]
end
