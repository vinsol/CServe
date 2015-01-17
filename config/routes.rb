Rails.application.routes.draw do
  devise_for :admins, :controllers => {
    :registrations => 'admins/registrations',
    :sessions => 'admins/sessions',
    :passwords => 'admins/passwords'
  }
  resources :companies, only: [:new, :create]
  resources :admins, only: [:index]
  # resources :admins do
    # get 'edit', on: :collection
    # patch 'edit', on: :collection
    # get 'add_admin', on: :new
    # post 'add_admin', on: :create
    # post 'change_state', on: :new
  # end
  get '/sign_up', to: 'companies#new'
  get '/add_admin', to: 'admins#new'
  post '/add_admin', to: 'admins#create'
  post '/change_state/:id', to: 'admins#change_state', as: 'change_state'
  get '/edit/:id', to: 'admins#edit', as: 'edit'
  patch '/edit/:id', to: 'admins#update'
  devise_scope :admin do
    match '/' => 'admins/sessions#new', :constraints => { :subdomain => /.+/ }, via: :all
    get "/sign_in", to: "admins/sessions#new"
    delete '/sign_out', to: 'admins/sessions#destroy'
  end
  root 'application#index'
end
