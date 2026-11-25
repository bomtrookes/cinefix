Rails.application.routes.draw do

  root 'movies#home'

  devise_for :users, skip: [:registrations]
  as :user do
    get    "users/edit", to: redirect("/settings"),          as: :edit_user_registration
    put    "users",      to: "users/registrations#update",  as: :user_registration
    patch  "users",      to: "users/registrations#update"
    delete "users",      to: "users/registrations#destroy"
  end

  get   "settings",                to: "settings#show",            as: :settings
  get   "settings/profile",        to: "settings#profile",         as: :profile_settings
  patch "settings/profile",        to: "settings#update_profile"
  get   "settings/email",          to: "settings#email",           as: :email_settings
  patch "settings/email",          to: "settings#update_email"
  get   "settings/password",       to: "settings#password",        as: :password_settings
  patch "settings/password",       to: "settings#update_password"
  post  "settings/password/reset", to: "settings#send_reset_link", as: :reset_link_settings
  get   "welcome",                 to: "settings#welcome",         as: :welcome
  patch "welcome",                 to: "settings#update_welcome"

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
  resources :people, only: [:show]
  resources :ratings, except: [:destroy]
  resources :watchlists, only: [:index, :create, :destroy]
  resources :watched_films, only: [:index, :create, :destroy]

  resources :feedbacks, only: [:new, :create]

  namespace :admin do
    resources :users, only: [:new, :create]
  end

  get '/404', to: 'errors#not_found'

  match "*path", to: "application#handle_routing_error", via: :all,
    constraints: ->(req) { !req.path.start_with?("/rails/") }

end
