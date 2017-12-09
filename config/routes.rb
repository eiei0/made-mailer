require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :businesses do
    collection do
      put 'import'
      get 'blank'
      get 'buttons'
      get 'flot'
      get 'forms'
      get 'grid'
      get 'icons'
      get 'login'
      get 'morris'
      get 'notifications'
      get 'panelswells'
      get 'tables'
      get 'typography'
    end
  end
  resources :mailers, only: [:create]
  get 'reports/cog'
  get 'reports/mailers_sent'

  mount Sidekiq::Web, at: '/sidekiq'

  root to: redirect('/businesses')
end
