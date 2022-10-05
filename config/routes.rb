Rails.application.routes.draw do
  devise_for :users
  root 'movies#index'
  resources :movies do
    resources :seances, except: [:show, :index] do
      resources :reservations
    end
  end 
  resources :seances
  resources :reservations do
    collection do
      get '/find_by_user', to: "reservations#find_by_user"
      get '/find_by_seance', to: "reservations#find_by_seance"
    end
    patch 'cancel', on: :member
    patch 'confirm', on: :member
  end
  resources :halls, except: :show
  resources :discounts, except: :show
end
