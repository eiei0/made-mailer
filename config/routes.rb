Rails.application.routes.draw do
  devise_for :users
  resources :businesses do
    collection do
      put 'import'
    end
  end
  resources :mailers, only: [:create]

  root to: 'businesses#index'
end
