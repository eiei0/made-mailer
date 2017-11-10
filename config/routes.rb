Rails.application.routes.draw do
  devise_for :users
  resources :businesses do
    post 'mailers/intro'
    post 'mailers/followup'
  end

  root to: 'businesses#index'
end
