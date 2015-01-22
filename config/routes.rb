Rails.application.routes.draw do
  resources :admins, except: [:destroy] do
    patch :change_state, on: :member
  end
  devise_for :admins, :controllers => {
    :registrations => 'admins/registrations',
    :sessions => 'admins/sessions',
    :passwords => 'admins/passwords'
  }
  controller :companies do
    get 'sign_up' => :new
    post 'sign_up' => :create
  end
  devise_scope :admin do
    match '/' => 'admins/sessions#new', :constraints => { :subdomain => /.+/ }, via: :all
    get :sign_in, to: "admins/sessions#new"
    delete :sign_out, to: 'admins/sessions#destroy'
  end
  root 'application#index'
end
