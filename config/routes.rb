require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :businesses do
    collection do
      put 'import'
    end
  end
  resources :mailers, only: [:create]
  resources :reports, only: [:index]

  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'businesses#index'
end
