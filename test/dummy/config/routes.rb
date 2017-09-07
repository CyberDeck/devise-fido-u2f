Rails.application.routes.draw do
  root to: 'pages#index'

  get 'secret', to: 'secret_pages#index'

  devise_for :users
end
