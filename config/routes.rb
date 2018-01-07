require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :dashboard, only: [:index]
  resources :businesses do
    collection do
      put 'import'
    end
  end
  resources :mailers, only: [:create, :destroy], param: :business_id
  resources :notifications, only: [:create, :index]
  get 'reports/cog'
  get 'reports/mailers_sent'
  resources :settings, only: [:index]


  authenticate :user do
    root to: 'dashboard#index', as: :authenticated_root
    mount Sidekiq::Web, at: '/sidekiq'
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end
end
