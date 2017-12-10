require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :dashboard, only: [:index]
  resources :businesses do
    collection do
      put 'import'
    end
  end
  resources :mailers, only: [:create]
  get 'reports/cog'
  get 'reports/mailers_sent'
  resources :settings, only: [:index]

  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'dashboard#index'
end
