Rails.application.routes.draw do
  devise_for :users
  root 'movies#index'
  resources :movies do
    resources :seances, except: [:show, :index] do
      resources :reservations
    end
  end     
resources :seances, :reservations
  resources :halls, except: :show
  resources :discounts
end
