Rails.application.routes.draw do
  root 'users#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'logout' => 'sessions#destroy', via: [:get, :delete]

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  resources :email_confirmations, only: [:show]
  resources :password_reset, only: [:show, :new, :update, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get 'profile' => 'freelancers#show'
  get 'create' => 'freelancers#create'
  get 'update' => 'freelancers#update'



  resources :freelancers, only: [:show, :new, :update, :edit, :create, :index], as: 'profile' do |f|
    resources :enquiries,only: [:new]
  end

  resources :enquiries,except: [:new]

end
