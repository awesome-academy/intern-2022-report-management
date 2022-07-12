Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "accounts#index"
    get "/index", to: "home#index"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    put "/manager/reports", to: "manager/reports#update"

    namespace :manager do
      resources :reports, only: %i(index show update)
      resources :users
    end

    resources :accounts, only: %i(index edit update)
    resources :reports
    resources :comments, only: :create
  end
end
