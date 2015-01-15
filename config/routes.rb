Rails.application.routes.draw do
  devise_for :admins, :controllers => {
    :registrations => 'admins/registrations',
    :sessions => 'admins/sessions',
    :passwords => 'admins/passwords'
  }
  resources :companies, only: [ :new, :create ]
  resources :admins, only: [ :index ]
  get '/sign_up', to: 'companies#new'
  get '/add_admin', to: 'admins#new'
  post '/add_admin', to: 'admins#create'
  post '/change_state', to: 'admins#change_state'
  get '/edit', to: 'admins#edit'
  patch '/edit', to: 'admins#update'
  devise_scope :admin do
    match '/' => 'admins/sessions#new', :constraints => { :subdomain => /.+/ }, via: :all
    get "/sign_in", to: "admins/sessions#new"
    delete '/sign_out', to: 'admins/sessions#destroy'
  end
  root 'application#index'
end
