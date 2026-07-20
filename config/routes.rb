Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  resources :nurses, only: [:index, :show]

  resources :appointments, only: [:create, :show, :update, :destroy]

  get "my-space", to: "pages#my_space", as: :my_space

  get "up" => "rails/health#show", as: :rails_health_check

  get 'confirmation/:id', to: 'pages#confirmation', as: 'confirmation'
end
