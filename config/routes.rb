require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :businesses do
    collection do
      put 'import'
    end
  end
  resources :mailers, only: [:create]
  get 'reports/cog'
  get 'reports/mailers_sent'

  mount Sidekiq::Web, at: '/sidekiq'

  root to: redirect('/businesses')
end
