Rails.application.routes.draw do
  resources :hates, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]

  get 'account_activations/edit'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get 'signup'  => 'users#new'

  root 'movies#index'

  resources :movies

  resources :users do
    member do
    get 'user_movies'
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

end