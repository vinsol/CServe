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
    get 'feedback' => :feedback
  end
  resources :tickets, only: [:create]
  controller :admins do
    get 'add_admin' => :new
    post 'add_admin' => :create
    post 'change_state/:id' => :change_state, as: 'change_state'
    get 'edit/:id' => :edit, as: 'edit'
    patch 'edit/:id' => :update
  end
  devise_scope :admin do
    get "/sign_in", to: "admins/sessions#new"
    delete '/sign_out', to: 'admins/sessions#destroy'
  end
  match '/' => 'companies#feedback', :constraints => { :subdomain => /.+/ }, via: :all
  root 'application#index'
end
