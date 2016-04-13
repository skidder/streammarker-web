StreamMarker::Application.routes.draw do
  root to: 'static_pages#home'
  get 'static_pages/home'
  resources :users, only: [:edit, :new, :create, :update, :created] do
    member do
      get :request_change_password
      put :change_password
      patch :change_password
    end
  end

  get 'dashboard', to: 'dashboard#index'

  get 'email_verification', to: 'email_verification#verify'

  get 'sensor_readings/query', to: 'sensor_readings#query'
  get 'sensor_readings/graph', to: 'sensor_readings#graph'

  resources :password_reset,  only: [:new, :create]
  resources :contacts,        only: [:new, :create]
  resources :sessions,        only: [:new, :create, :destroy]
  resources :relays,          only: [:edit, :new, :create, :show, :destroy, :update]
  resources :sensors,         only: [:create, :edit, :show, :update, :index]

  match '/signup', to: 'users#new', via: [:get, :post]
  match '/signin', to: 'sessions#new', via: [:get, :post]
  match '/signout', to: 'sessions#destroy', via: :delete

  namespace :system do
    resources :configs, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end
end
