Rails.application.routes.draw do

  resources :admins, except: [:destroy, :show] do
    patch :change_state, on: :member
  end

  devise_for :admins, path: :admin,  :controllers => {
    :registrations => 'admins/registrations',
    :sessions => 'admins/sessions',
    :passwords => 'admins/passwords'
  }

  controller :companies do
    get 'sign_up' => :new
    post 'sign_up' => :create
    get 'feedback' => :feedback
  end

  resources :tickets, only: [:create, :index]

  devise_scope :admin do
    get "/sign_in", to: "admins/sessions#new"
    delete '/sign_out', to: 'admins/sessions#destroy'
  end

  match '/' => 'companies#feedback', :constraints => { :subdomain => /.+/ }, via: :all

  root 'application#index'

end
