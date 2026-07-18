Rails.application.routes.draw do
  # Authentification
  devise_for :users

  # Page d'accueil
  root to: "pages#home"

  # Infirmières
  resources :nurses, only: [:index, :show]

  # Rendez-vous
  resources :appointments, only: [:new, :create, :show]

  # Mon espace
  get "my-space", to: "pages#my_space", as: :my_space

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
