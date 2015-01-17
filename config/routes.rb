Rails.application.routes.draw do
  devise_for :admins, :controllers => {
    :registrations => 'admins/registrations',
    :sessions => 'admins/sessions',
    :passwords => 'admins/passwords'
  }
  resources :admins, only: [:index]
  controller :companies do
    get 'sign_up' => :new
    post 'sign_up' => :create
  end
  controller :admins do
    get 'add_admin' => :new
    post 'add_admin' => :create
  end
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
