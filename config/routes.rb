Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  namespace :api do
    post "/graphql", to: "graphql#execute"
    post "login", to: "authentication#login"

    resources :movies do
      member do
        post "follow"
        delete "unfollow"
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  root "application#api_status"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "posts#index"
end
