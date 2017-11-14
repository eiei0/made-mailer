Rails.application.routes.draw do
  devise_for :users
  resources :businesses do
    post 'mailers/intro'
    post 'mailers/followup'
    collection do
      put 'import'
      get 'search'
    end
  end

  root to: 'businesses#index'
end
