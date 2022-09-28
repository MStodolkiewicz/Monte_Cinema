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
      get '/find_reservations_by_user', to: "reservations#find_reservations_by_user"
      get '/find_reservations_by_seance', to: "reservations#find_reservations_by_seance"
    end
  end
  resources :halls, except: :show
  resources :discounts 
end
