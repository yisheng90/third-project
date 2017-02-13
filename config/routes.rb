Rails.application.routes.draw do
  root 'users#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  resources :users do
    member do
      get :confirm_email
    end
  end

  resources :email_confirmations, only: [:show]
  resources :password_reset, only: [:show, :new, :update, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
