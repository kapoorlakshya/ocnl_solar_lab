Rails.application.routes.draw do
  resources :users
  resources :user_sessions
  resources :acm300_logs, only: [:index], path: 'dc_power_data'
  resources :flukes, only: [:index], path: 'sensor_data'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'flukes#index'
  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'user_sessions/destroy'
  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
  get '/graphs' => 'pages#graphs'
  get '/documents_and_downloads' => 'pages#documents_and_downloads'
  get '/about' => 'pages#about'
  get '/gallery' => 'pages#gallery'
  get '/contact' => 'pages#contact'
  get '/power_by_module' => 'pages#power_by_module'

end
