Rails.application.routes.draw do
  devise_for :users

  root 'movies#index'

  resources :movies, only: [:index, :show] do
    resources :ratings, only: [:index, :new, :create]
  end

  resources :ratings, only: [:index, :new, :create] do
    resources :movie_ratings, only: [:index]
  end
end
