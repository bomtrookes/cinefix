Rails.application.routes.draw do

  root 'movies#home'

  devise_for :users, skip: [:registrations]
  as :user do
    get    "users/edit", to: "devise/registrations#edit",    as: :edit_user_registration
    put    "users",      to: "devise/registrations#update",  as: :user_registration
    patch  "users",      to: "devise/registrations#update"
    delete "users",      to: "devise/registrations#destroy"
  end

  get '/feed', to: 'activities#feed'
  post 'watched', to: 'watched_films#watched'
  delete 'watched', to: 'watched_films#unwatch'

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

  match "*path", to: "application#handle_routing_error", via: :all,
    constraints: ->(req) { !req.path.start_with?("/rails/") }

  get '/404', to: 'errors#not_found'


end
