Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "accounts#index"
    get "/index", to: "home#index"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"
    put "/manager/reports", to: "manager/reports#update"

    namespace :manager do
      resources :reports
    end

    resources :accounts, only: %i(index edit)
    resources :reports
  end
end
