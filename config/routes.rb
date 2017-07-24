Rails.application.routes.draw do
  # get 'sessions/new'
  #
  # get 'sessions/create'
  #
  # get 'sessions/destroy'
  #
  # get 'users/new'
  #
  # get 'welcome/index'
  #
  # get 'welcome/about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get('/', {to: 'welcome#index', as: 'home'})

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  resources :ideas do
    resources :reviews, only: [:create, :destroy]
  end
end
