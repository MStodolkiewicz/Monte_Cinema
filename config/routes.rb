require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users
  root 'movies#index'
  resources :movies do
    resources :seances, except: %i[show index] do
      resources :reservations
    end
  end
  resources :seances
  resources :reservations, except: %i[edit update] do
    collection do
      get '/find_by_user', to: "reservations#find_by_user"
      get '/find_by_seance', to: "reservations#find_by_seance"
      post 'create_as_manager', to: 'reservations#create_as_manager'
      post 'create_as_guest', to: 'reservations#create_as_guest'
    end
    patch 'cancel', on: :member
    patch 'confirm', on: :member
  end
  resources :halls, except: :show
  resources :discounts, except: :show
end
