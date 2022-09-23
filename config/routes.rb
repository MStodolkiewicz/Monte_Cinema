Rails.application.routes.draw do
  devise_for :users
  root 'movies#index'
  resources :movies do
    resources :seances, except: [:show, :index]
  end     
resources :seances
  resources :halls, except: :show
  resources :discounts
end
