Rails.application.routes.draw do
  
  resources :admins, except: [:destroy, :show] do
    member do
      patch :enable
      patch :disable
    end
  end


  devise_for :admins, path: :admin,  controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions',
    passwords: 'admins/passwords'
  }

  namespace :admins do
    resources :articles do
      member do
        patch :publish
        patch :unpublish
      end
    end
    resources :categories, except: :show do
      member do
        patch :enable
        patch :disable
      end
    end
  end

  resources :articles, only: [:index]

  controller :companies do
    get 'sign_up' => :new
    post 'sign_up' => :create
  end

  resources :tickets, only: [:create, :index, :show, :new] do
    member do
      patch :resolve
      patch :close
      patch :reopen
      patch :assign
      patch :reassign
    end
    resources :comments, only: [:create]
  end

  devise_scope :admin do
    get '/sign_in', to: 'admins/sessions#new'
    delete '/sign_out', to: 'admins/sessions#destroy'
  end

  match '/' => 'articles#index', constraints: { subdomain: /.+/ }, via: :all

  root 'application#index'

end
